import ComposableArchitecture
import Stores
import SwiftUI
import Traq

struct UnreadChannelList: View {
    private let store: ServiceCore.Store
    private let unreadChannels: [TraqAPI.UnreadChannel]
    private let channelDictionary: [UUID: TraqAPI.Channel]
    @Binding private var openChannelContentView: Bool
    @Binding private var destChannel: TraqAPI.Channel

    public init(
        store: ServiceCore.Store,
        unreadChannels: [TraqAPI.UnreadChannel],
        channelDictionary: [UUID: TraqAPI.Channel],
        openChannelContentView: Binding<Bool>,
        destChannel: Binding<TraqAPI.Channel>
    ) {
        self.store = store
        self.unreadChannels = unreadChannels
        self.channelDictionary = channelDictionary
        _destChannel = destChannel
        _openChannelContentView = openChannelContentView
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            List(unreadChannels, id: \.channelId) { unreadChannel in
                if
                    let channel = channelDictionary[unreadChannel.channelId],
                    let channelPath = channelDictionary.getLongPath(from: channel.id)
                {
                    Button {
                        viewStore.send(.message(.fetchMessages(channelId: unreadChannel.channelId)))

                        destChannel = channel
                        openChannelContentView = true
                    } label: {
                        HStack {
                            Image(systemName: "number")
                            Text(channelPath)
                            Spacer()
                            Text("\(unreadChannel.count)")
                                .foregroundColor(.gray)
                        }
                    }
                    .foregroundColor(.black)
                }
            }
        }
    }
}
