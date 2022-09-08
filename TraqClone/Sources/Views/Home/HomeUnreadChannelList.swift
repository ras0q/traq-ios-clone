import SwiftUI
import Traq

struct HomeUnreadChannelList<Destination>: View where Destination: View {
    private let unreadChannels: [TraqAPI.UnreadChannel]
    private let channelDictionary: [UUID: TraqAPI.Channel]
    private let destination: (TraqAPI.Channel) -> Destination

    public init(
        unreadChannels: [TraqAPI.UnreadChannel],
        channelDictionary: [UUID: TraqAPI.Channel],
        destination: @escaping (TraqAPI.Channel) -> Destination
    ) {
        self.unreadChannels = unreadChannels
        self.channelDictionary = channelDictionary
        self.destination = destination
    }

    var body: some View {
        List(unreadChannels, id: \.channelId) { unreadChannel in
            if let channel = channelDictionary[unreadChannel.channelId] {
                if let channelPath = channelDictionary.getLongPath(from: channel.id) {
                    NavigationLink(
                        destination: { destination(channel) }, label: {
                            if #available(iOS 15.0, *) {
                                Text(channelPath)
                                    .badge(unreadChannel.count)
                            } else {
                                Text(channelPath)
                            }
                        }
                    )
                }
            }
        }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HomeUnreadChannelList(
            unreadChannels: [],
            channelDictionary: [:],
            destination: { _ in EmptyView() }
        )
    }
}
