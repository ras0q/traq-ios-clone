import Activity
import Channel
import Clip
import Home
import SwiftUI
import User

public struct RootView: View {
    public init() {}
    public var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            ChannelView(channelTree: .sampleChannelTree)
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
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
