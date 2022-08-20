import ChannelContent
import ChannelTree
import SwiftUI

public struct ChannelView: View {
    private let channelTree: ChannelTree

    public init(channelTree: ChannelTree) {
        self.channelTree = channelTree
    }

    public var body: some View {
        NavigationView {
            List(channelTree.children ?? [], id: \.id, children: \.children) { channel in
                NavigationLink(
                    destination: ChannelContentView(id: channel.id),
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

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(channelTree: .sampleChannelTree)
    }
}
