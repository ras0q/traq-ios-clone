import SwiftUI

public struct ChannelTreeView<Destination>: View where Destination: View {
    private let topChannels: [ChannelNode]
    private let desctination: (ChannelNode) -> Destination

    public init(topChannels: [ChannelNode], destination: @escaping (ChannelNode) -> Destination) {
        self.topChannels = topChannels
        desctination = destination
    }

    public var body: some View {
        NavigationView {
            List(topChannels, id: \.id, children: \.children) { channel in
                NavigationLink(
                    destination: desctination(channel),
                    label: {
                        Image(systemName: "number")
                        Text(channel.name)
                    }
                )
            }
            .listStyle(SidebarListStyle())
            .navigationBarTitle("チャンネル")
        }
    }
}

struct ChannelTreeView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelTreeView(topChannels: ChannelNode.mockTopChannels) { _ in
            EmptyView()
        }
    }
}
