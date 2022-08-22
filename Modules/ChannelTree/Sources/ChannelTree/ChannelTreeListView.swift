import SwiftUI

public struct ChannelTreeListView<Destination>: View where Destination: View {
    private let topChannels: [ChannelNode]
    private let destination: (ChannelNode) -> Destination
    @State private var openChannelContentView = false
    @State private var destChannel: ChannelNode?

    public init(topChannels: [ChannelNode], destination: @escaping (ChannelNode) -> Destination) {
        self.topChannels = topChannels
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
            ChannelTreeListView(topChannels: ChannelNode.mockTopChannels) { _ in
                EmptyView()
            }
        }
    }
}
