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
                List(viewStore.userMe.unreadChannels, id: \.channelId) { channel in
                    if #available(iOS 15.0, *) {
                        Text(viewStore.channel.channelDictionary.getLongPath(from: channel.channelId))
                            .badge(channel.count)
                    } else {
                        Text(viewStore.channel.channelDictionary.getShortPath(from: channel.channelId))
                    }
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
