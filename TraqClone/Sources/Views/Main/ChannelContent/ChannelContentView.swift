import ComposableArchitecture
import Models
import Stores
import SwiftUI
import Traq

public struct ChannelContentView: View {
    private let store: ServiceCore.Store
    private let channel: TraqAPI.Channel

    public init(store: ServiceCore.Store, channel: TraqAPI.Channel) {
        self.store = store
        self.channel = channel
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ChannelContentHeader(channel, viewStore.channel.channelDictionary)
                MessageScroll(
                    (viewStore.message.channelMesssages[channel.id] ?? [])
                        .sorted { $0.createdAt < $1.createdAt },
                    viewStore.user.userDictionary
                )
                MessageInput(needAlert: channel.force)
            }
        }
    }
}

struct ChannelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentView(
            store: .defaultStore,
            channel: .mock
        )
    }
}