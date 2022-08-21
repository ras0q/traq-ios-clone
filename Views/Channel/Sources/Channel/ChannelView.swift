import ChannelContent
import ChannelTree
import SwiftUI

public struct ChannelView: View {
    private let topChannels: [ChannelNode]

    public init(topChannels: [ChannelNode] = ChannelNode.mockTopChannels) {
        self.topChannels = topChannels
    }

    public var body: some View {
        ChannelTreeView(topChannels: topChannels) { channel in
            ChannelContentView(channel: channel)
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}
