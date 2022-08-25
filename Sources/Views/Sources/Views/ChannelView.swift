import Components
import ComposableArchitecture
import Stores
import SwiftUI

public struct ChannelView: View {
    private let store: AppStore

    public init(store: AppStore) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                ChannelTreeListView(channels: viewStore.channels) { channel in
                    ChannelContentView(channel: channel)
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
        ChannelView(store: .defaultAppStore)
    }
}
