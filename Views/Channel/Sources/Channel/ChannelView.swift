import ChannelTree
import SwiftUI

public struct ChannelView: View {
    private let channelTree: ChannelTree

    public init(channelTree: ChannelTree) {
        self.channelTree = channelTree
    }

    public var body: some View {
        List(channelTree.children ?? [], id: \.id, children: \.children) {
            Image(systemName: "number")
            Text($0.name)
        }.listStyle(SidebarListStyle())
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(channelTree: .sampleChannelTree)
    }
}
