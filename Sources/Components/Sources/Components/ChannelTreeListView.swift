import Models
import Repositories
import SwiftUI

public struct ChannelTreeListView<Destination>: View where Destination: View {
    @ObservedObject var topChannels: ChannelNodes = .init(channels: [])
    private let destination: (ChannelNode) -> Destination
    @State private var openChannelContentView: Bool = false
    @State private var destChannel: ChannelNode?
    private var channelRepository: ChannelRepository = ChannelRepositoryImpl()

    public init(destination: @escaping (ChannelNode) -> Destination) {
        self.destination = destination

        channelRepository.fetchChannels { [self] response in
            guard let topChannels = ChannelNode(channels: response._public).children else {
                print("topChannels is nil")
                return
            }

            self.topChannels.channels = topChannels
        }
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

            List(topChannels.channels, id: \.id, children: \.children) { channel in
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
        .navigationTitle("チャンネル")
    }
}
