import Components
import ComposableArchitecture
import Stores
import SwiftUI

public struct ChannelView: View {
    private let store: ChannelCore.Store

    public init(store: ChannelCore.Store) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ChannelTreeListView(viewStore.channelDictionary) { channel in
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
        ChannelView(
            store: ServiceCore.Store.defaultStore
                .scope(
                    state: { $0.channel },
                    action: ServiceCore.Action.channel
                )
        )
    }
}
