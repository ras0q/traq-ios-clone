import ComposableArchitecture
import Stores
import SwiftUI

public struct RootView: View {
    private let store: AppCore.Store

    public init(store: AppCore.Store = .defaultStore) {
        UITabBar.appearance().backgroundColor = UIColor.white

        self.store = store

        let viewStore = ViewStore(store)
        viewStore.send(.service(.websocket(.waitForNextEvent)))
        viewStore.send(.service(.userMe(.fetchMe)))
    }

    public var body: some View {
        SwitchStore(store) {
            // 未ログイン時: ログイン画面を表示
            CaseLet(state: /AppCore.State.auth, action: AppCore.Action.auth) { loginStore in
                LoginView(store: loginStore)
            }
            // ログイン時: サービス画面を表示
            CaseLet(state: /AppCore.State.service, action: AppCore.Action.service) { authStore in
                TabView {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    ChannelView(store: authStore.scope(state: { $0.channel }, action: ServiceCore.Action.channel))
                        .tabItem {
                            Image(systemName: "number")
                            Text("Channel")
                        }
                    ActivityView()
                        .tabItem {
                            Image(systemName: "bolt.fill")
                            Text("Activity")
                        }
                    UserView(store: authStore.scope(state: { $0.user }, action: ServiceCore.Action.user))
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("User")
                        }
                    ClipView()
                        .tabItem {
                            Image(systemName: "bookmark.fill")
                            Text("Bookmark")
                        }
                }
            }
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
