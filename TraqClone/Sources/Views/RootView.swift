import ComposableArchitecture
import Stores
import SwiftUI

public struct RootView: View {
    private let store: AppCore.Store

    public init(store: AppCore.Store = .defaultAppStore) {
        UITabBar.appearance().backgroundColor = UIColor.white

        self.store = store

        // TODO: データの初期化方法を綺麗にする
        let viewStore = ViewStore(store)
        viewStore.send(.auth(.fetchMe))
        viewStore.send(.channel(.fetchChannels))
        viewStore.send(.channel(.user(.fetchUsers)))
        viewStore.send(.user(.fetchUsers))
    }

    public var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ChannelView(store: store.scope(state: { $0.channel }, action: AppCore.Action.channel))
                .tabItem {
                    Image(systemName: "number")
                    Text("Channel")
                }
            ActivityView()
                .tabItem {
                    Image(systemName: "bolt.fill")
                    Text("Activity")
                }
            UserView(store: store.scope(state: { $0.user }, action: AppCore.Action.user))
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("User")
                }
            ClipView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Bookmark")
                }
            LoginView(store: store.scope(state: { $0.auth }, action: AppCore.Action.auth))
                .tabItem {
                    Image(systemName: "person")
                    Text("Login")
                }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
