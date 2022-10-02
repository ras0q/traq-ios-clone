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

    @State private var channelPath: [TraqAPI.Channel] = []

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack(path: $channelPath) {
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
                                channelPath: $channelPath
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
                            channelPath: $channelPath
                        )
                    } header: {
                        Text("未読")
                            .font(.title2)
                    }
                }
                .navigationDestination(for: TraqAPI.Channel.self) { channel in
                    ChannelContentView(store: store, channel: channel)
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(store: .defaultStore)
    }
}
