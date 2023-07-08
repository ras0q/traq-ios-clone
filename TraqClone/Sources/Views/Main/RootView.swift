import ComposableArchitecture
import Stores
import SwiftUI

public struct RootView: View {
    private let store: StoreOf<AppCore>

    public init(store: StoreOf<AppCore> = .defaultStore) {
        UITabBar.appearance().backgroundColor = UIColor.white

        self.store = store

        store.send(.service(.receiveWsEvent))
        store.send(.service(.userMe(.fetchMe)))
        store.send(.service(.fetchStamps))
    }

    public var body: some View {
        SwitchStore(store) {
            // 未ログイン時: ログイン画面を表示
            CaseLet(state: /AppCore.State.auth, action: AppCore.Action.auth) { loginStore in
                LoginView(store: loginStore)
            }
            // ログイン時: サービス画面を表示
            CaseLet(state: /AppCore.State.service, action: AppCore.Action.service) { serviceStore in
                TabView {
                    HomeView(store: serviceStore)
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                    ChannelView(store: serviceStore)
                        .tabItem {
                            Image(systemName: "number")
                            Text("Channel")
                        }
                    ActivityView(store: serviceStore)
                        .tabItem {
                            Image(systemName: "bolt.fill")
                            Text("Activity")
                        }
                    UserView(store: serviceStore)
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
