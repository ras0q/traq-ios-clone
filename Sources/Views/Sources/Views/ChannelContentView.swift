import Components
import ComposableArchitecture
import Models
import Stores
import SwiftUI

public struct ChannelContentView: View {
    private let store: AppStore
    private let channel: ChannelNode

    public init(store: AppStore, channel: ChannelNode) {
        self.store = store
        self.channel = channel
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ChannelContentHeaderView(channel, viewStore.channelDictionary)
            MessageScrollView(channel.id, viewStore.userDictionary)
            MessageInputView()
        }
    }
}

struct ChannelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentView(store: .defaultAppStore, channel: .init(
            id: UUID(),
            parentID: nil,
            name: "preview",
            children: []
        ))
    }
}
