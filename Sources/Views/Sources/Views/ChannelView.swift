import Components
import SwiftUI

public struct ChannelView: View {
    public init() {}

    public var body: some View {
        NavigationView {
            ChannelTreeListView { channel in
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

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}
