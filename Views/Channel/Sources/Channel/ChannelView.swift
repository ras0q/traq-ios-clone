import ChannelContent
import ChannelTree
import SwiftUI

public struct ChannelView: View {
    private let channelTree: ChannelTree

    public init(channelTree: ChannelTree) {
        self.channelTree = channelTree
    }

    public var body: some View {
        ChannelTreeView(channelTree: channelTree) { channel in
            ChannelContentView(channel: channel)
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(channelTree: .mockChannelTree)
    }
}
