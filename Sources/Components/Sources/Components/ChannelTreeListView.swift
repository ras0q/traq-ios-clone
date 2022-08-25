import Models
import SwiftUI
import Traq

public struct ChannelTreeListView<Destination>: View where Destination: View {
    // input parameters
    private let topChannels: [ChannelNode]
    private let destination: (ChannelNode) -> Destination

    // properies managed by SwiftUI
    @State private var openChannelContentView: Bool = false
    @State private var destChannel: ChannelNode?

    public init(channels: [TraqAPI.Channel], destination: @escaping (ChannelNode) -> Destination) {
        topChannels = ChannelNode(channels: channels).children ?? []
        self.destination = destination
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

            List(topChannels, id: \.id, children: \.children) { channel in
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
            ChannelTreeListView(channels: ChannelNode.mockChannels) { _ in
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
