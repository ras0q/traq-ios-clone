import ComposableArchitecture
import Stores
import SwiftUI
import Traq

public struct HomeView: View {
    private let store: ServiceCore.Store

    public init(store: ServiceCore.Store) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                HomeUnreadChannelList(
                    unreadChannels: viewStore.userMe.unreadChannels,
                    channelDictionary: viewStore.channel.channelDictionary
                ) { channel in
                    ChannelContentView(store: store, channel: channel)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .defaultStore)
    }
}
