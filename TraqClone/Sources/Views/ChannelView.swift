import Components
import ComposableArchitecture
import Stores
import SwiftUI

public struct ChannelView: View {
    private let store: ServiceCore.Store

    public init(store: ServiceCore.Store) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ChannelTreeListView(viewStore.channel.channelDictionary) { channel in
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
        ChannelView(store: ServiceCore.Store.defaultStore)
    }
}
