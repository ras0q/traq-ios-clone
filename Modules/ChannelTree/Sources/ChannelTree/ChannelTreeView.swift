import SwiftUI

public struct ChannelTreeView<Destination>: View where Destination: View {
    private let channelTree: ChannelTree
    private let desctination: (ChannelTree) -> Destination

    public init(channelTree: ChannelTree, destination: @escaping (ChannelTree) -> Destination) {
        self.channelTree = channelTree
        desctination = destination
    }

    public var body: some View {
        NavigationView {
            List(channelTree.children ?? [], id: \.id, children: \.children) { channel in
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
        ChannelTreeView(channelTree: .mockChannelTree) { _ in
            EmptyView()
        }
    }
}
