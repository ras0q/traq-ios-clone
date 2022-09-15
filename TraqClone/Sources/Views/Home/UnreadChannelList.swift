import SwiftUI
import Traq

struct UnreadChannelList<Destination>: View where Destination: View {
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
                    ChannelNavigationLink(
                        channelPath: channelPath,
                        count: unreadChannel.count
                    ) {
                        destination(channel)
                    }
                }
            }
        }
    }
}

struct UnreadChannelList_Previews: PreviewProvider {
    static var previews: some View {
        UnreadChannelList(
            unreadChannels: [],
            channelDictionary: [:],
            destination: { _ in EmptyView() }
        )
    }
}
