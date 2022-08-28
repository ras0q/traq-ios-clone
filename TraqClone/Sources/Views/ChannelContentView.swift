import Components
import ComposableArchitecture
import Models
import Stores
import SwiftUI

public struct ChannelContentView: View {
    private let store: ChannelCore.Store
    private let channel: ChannelNode

    public init(store: ChannelCore.Store, channel: ChannelNode) {
        self.store = store
        self.channel = channel
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ChannelContentHeaderView(channel, viewStore.channelDictionary)
            MessageScrollView(channel.id, viewStore.user.userDictionary)
            MessageInputView()
        }
    }
}

struct ChannelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentView(
            store: ServiceCore.Store.defaultStore
                .scope(
                    state: { $0.channel },
                    action: ServiceCore.Action.channel
                ),
            channel: .init(
                id: UUID(),
                parentID: nil,
                name: "preview",
                children: []
            )
        )
    }
}
