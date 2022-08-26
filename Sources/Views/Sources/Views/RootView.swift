import Stores
import SwiftUI

public struct RootView: View {
    private let store: AppStore

    public init(appStore: AppStore = .defaultAppStore) {
        UITabBar.appearance().backgroundColor = UIColor.white

        store = appStore
        store.initializeData()
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
            UserView(store: store)
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("User")
                }
            ClipView()
                .tabItem {
                    Image(systemName: "bookmark.fill")
                    Text("Bookmark")
                }
            LoginView(store: store)
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
