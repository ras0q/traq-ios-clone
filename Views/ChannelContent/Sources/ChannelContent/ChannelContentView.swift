import ChannelTree
import Message
import SwiftUI

public struct ChannelContentView: View {
    private let channel: ChannelTree

    public init(channel: ChannelTree) {
        self.channel = channel
    }

    public var body: some View {
        ChannelContentHeader(channel: channel)
        ScrollView {
            ForEach(MessageElement.sampleMessages, id: \.id) { message in
                MessageElement(message: message)
            }
        }
    }
}

struct ChannelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentView(channel: .mockChannelTree.children![0])
    }
}
