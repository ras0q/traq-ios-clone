import ChannelContent
import ChannelTree
import SwiftUI

public struct ChannelView: View {
    public init() {}

    public var body: some View {
        NavigationView {
            ChannelTreeListView { channel in
                ChannelContentView(channel: channel)
            }
            .navigationTitle("チャンネル")
        }
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}
