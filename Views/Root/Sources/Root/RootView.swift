import Activity
import Channel
import Clip
import Home
import Login
import SwiftUI
import User

public struct RootView: View {
    public init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }

    public var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ChannelView()
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
