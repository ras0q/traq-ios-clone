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
                List(viewStore.userMe.unreadChannels, id: \.channelId) { unreadChannel in
                    if let channel = viewStore.channel.channelDictionary[unreadChannel.channelId] {
                        if let channelPath = viewStore.channel.channelDictionary.getLongPath(from: channel.id) {
                            NavigationLink(
                                destination: {
                                    ChannelContentView(store: store, channel: channel)
                                }, label: {
                                    if #available(iOS 15.0, *) {
                                        Text(channelPath)
                                            .badge(unreadChannel.count)
                                    } else {
                                        Text(channelPath)
                                    }
                                }
                            )
                        }
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
