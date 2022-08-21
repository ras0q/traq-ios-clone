import ChannelTree
import Message
import SwiftUI

public struct ChannelContentView: View {
    private let channel: ChannelNode

    public init(channel: ChannelNode) {
        self.channel = channel
    }

    public var body: some View {
        ChannelContentHeader(channel: channel)
        ScrollView {
            ForEach(MessageElementView.sampleMessages, id: \.id) { message in
                MessageElementView(message: message)
            }
        }
    }
}

struct ChannelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentView(channel: .mockTopChannels[0])
    }
}
