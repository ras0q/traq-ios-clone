import ComposableArchitecture
import Models
import Stores
import SwiftUI

public struct ChannelContentView: View {
    private let store: ServiceCore.Store
    private let channel: ChannelNode

    public init(store: ServiceCore.Store, channel: ChannelNode) {
        self.store = store
        self.channel = channel
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ChannelContentHeader(channel, viewStore.channel.channelDictionary)
            MessageScroll(channel.id, viewStore.user.userDictionary)
            MessageInput(needAlert: channel.force)
        }
    }
}

struct ChannelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentView(
            store: ServiceCore.Store.defaultStore,
            channel: .init(
                id: UUID(),
                parentID: nil,
                name: "preview",
                children: []
            )
        )
    }
}
