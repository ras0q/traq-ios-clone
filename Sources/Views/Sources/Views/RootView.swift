import ComposableArchitecture
import Stores
import SwiftUI

public struct RootView: View {
    private let store: AppStore = .defaultAppStore
    @ObservedObject var viewStore: ViewStore<ViewState, AppAction>

    public init() {
        UITabBar.appearance().backgroundColor = UIColor.white

        viewStore = ViewStore(store.scope(state: ViewState.init(state:)))
        viewStore.send(.fetchChannels)
    }

    public var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ChannelView(store: store)
                .tabItem {
                    Image(systemName: "number")
                    Text("Channel")
                }
            ActivityView()
                .tabItem {
                    Image(systemName: "bolt.fill")
                    Text("Activity")
                }
            UserView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("User")
                }
            ClipView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Bookmark")
                }
            LoginView()
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
