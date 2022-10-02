import ComposableArchitecture
import Models
import Stores
import SwiftUI
import Traq

public struct ChannelView: View {
    private let store: ServiceCore.Store

    public init(store: ServiceCore.Store) {
        self.store = store
    }

    @State private var channelPath: [TraqAPI.Channel] = []

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationStack(path: $channelPath) {
                ChannelTreeList(
                    store: store,
                    channels: ChannelNode(from: viewStore.channel.channelDictionary).children ?? [],
                    channelPath: $channelPath
                )
                .navigationDestination(for: TraqAPI.Channel.self) { channel in
                    ChannelContentView(store: store, channel: channel)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("チャンネル")
                            .font(.largeTitle)
                            .bold()
                    }
                }
            }
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView(store: .defaultStore)
    }
}
