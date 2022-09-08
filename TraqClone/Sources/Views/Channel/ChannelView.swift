import ComposableArchitecture
import Models
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
                ChannelTreeList(
                    ChannelNode(from: viewStore.channel.channelDictionary).children ?? []
                ) { channel in
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
