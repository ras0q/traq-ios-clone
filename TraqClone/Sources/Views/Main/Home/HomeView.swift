import ComposableArchitecture
import Models
import Stores
import SwiftUI
import Traq

public struct HomeView: View {
    private let store: ServiceCore.Store

    public init(store: ServiceCore.Store) {
        self.store = store
    }

    public var body: some View {
        NavigationView {
            WithViewStore(store) { viewStore in
                WithNavigationLinkToChannelContent(store: store) { openChannelContentView, destChannel in
                    Form {
                        Section {
                            if let homeChannel = ChannelNode(
                                rootId: viewStore.userMe.userMe?.homeChannel ?? UUID(),
                                dictionary: viewStore.channel.channelDictionary,
                                includeArchived: false
                            ) {
                                ChannelTreeList(
                                    store: store,
                                    channels: [homeChannel],
                                    openChannelContentView: openChannelContentView,
                                    destChannel: destChannel
                                )
                            } else {
                                ProgressView()
                            }
                        } header: {
                            Text("ホームチャンネル")
                                .font(.title2)
                        }

                        Section {
                            UnreadChannelList(
                                store: store,
                                unreadChannels: viewStore.userMe.unreadChannels,
                                channelDictionary: viewStore.channel.channelDictionary,
                                openChannelContentView: openChannelContentView,
                                destChannel: destChannel
                            )
                        } header: {
                            Text("未読")
                                .font(.title2)
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("ホーム")
                        .font(.largeTitle)
                        .bold()
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
