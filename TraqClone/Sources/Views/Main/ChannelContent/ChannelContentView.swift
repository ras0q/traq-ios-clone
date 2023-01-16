import ComposableArchitecture
import Models
import Stores
import SwiftUI
import Traq

public struct ChannelContentView: View {
    private let store: StoreOf<ServiceCore>
    private let channel: TraqAPI.Channel

    public init(store: StoreOf<ServiceCore>, channel: TraqAPI.Channel) {
        self.store = store
        self.channel = channel
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ChannelContentHeader(channel, viewStore.channel.channelDictionary)
                MessageScroll(store, channelId: channel.id)
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
