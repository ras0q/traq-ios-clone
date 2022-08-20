import SwiftUI

public struct ChannelContentView: View {
    private let channelId: UUID

    public init(id: UUID) {
        channelId = id
    }

    public var body: some View {
        Text("Hello ChannelContent!")
        Text("channelId is \(channelId)")
    }
}

struct ChannelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentView(id: UUID())
    }
}
