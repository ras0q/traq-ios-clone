import Models
import SwiftUI
import Traq

public struct ChannelTreeListView<Destination>: View where Destination: View {
    // input parameters
    private let destination: (ChannelNode) -> Destination

    // properies managed by SwiftUI
    @State private var openChannelContentView: Bool = false
    @State private var destChannel: ChannelNode?

    // objects with publisher on change
    @ObservedObject private var topChannels: ChannelNodes = .init()

    private final class ChannelNodes: ObservableObject {
        @Published fileprivate var data: [ChannelNode] = .init()

        func fetch() {
            TraqAPI.ChannelAPI.getChannels(includeDm: false) { [self] response, error in
                guard error == nil else {
                    print(error!)
                    return
                }

                guard let response = response else {
                    print("response is nil")
                    return
                }

                guard let topChannels = ChannelNode(channels: response._public).children else {
                    print("topChannels is nil")
                    return
                }

                self.data = topChannels
            }
        }
    }

    public init(destination: @escaping (ChannelNode) -> Destination) {
        self.destination = destination

        topChannels.fetch()
    }

    public var body: some View {
        ZStack {
            NavigationLink(
                isActive: $openChannelContentView,
                destination: { destination(destChannel ?? .mockTopChannels[0]) }
            ) {
                EmptyView()
            }
            .hidden()

            List(topChannels.data, id: \.id, children: \.children) { channel in
                let imageView = Image(systemName: "number")
                    .fixedSize()
                    .padding(4)

                if (channel.children ?? []).isEmpty {
                    imageView
                } else {
                    imageView
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }

                // use Text as a Button
                Text(channel.name)
                    .onTapGesture {
                        destChannel = channel
                        openChannelContentView = true
                    }
            }
        }
    }
}

struct ChannelTreeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChannelTreeListView { _ in
                EmptyView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("チャンネル")
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}
