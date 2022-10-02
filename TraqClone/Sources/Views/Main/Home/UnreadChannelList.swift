import ComposableArchitecture
import Stores
import SwiftUI
import Traq

struct UnreadChannelList: View {
    private let store: ServiceCore.Store
    private let unreadChannels: [TraqAPI.UnreadChannel]
    private let channelDictionary: [UUID: TraqAPI.Channel]
    @Binding private var channelPath: [TraqAPI.Channel]

    public init(
        store: ServiceCore.Store,
        unreadChannels: [TraqAPI.UnreadChannel],
        channelDictionary: [UUID: TraqAPI.Channel],
        channelPath: Binding<[TraqAPI.Channel]>
    ) {
        self.store = store
        self.unreadChannels = unreadChannels
        self.channelDictionary = channelDictionary
        _channelPath = channelPath
    }

    var body: some View {
        WithViewStore(store) { viewStore in
            List(unreadChannels, id: \.channelId) { unreadChannel in
                if
                    let channel = channelDictionary[unreadChannel.channelId],
                    let channelPathName = channelDictionary.getLongPath(from: channel.id)
                {
                    Button {
                        viewStore.send(.message(.fetchMessages(channelId: unreadChannel.channelId)))
                        channelPath.append(channel)
                    } label: {
                        HStack {
                            Image(systemName: "number")
                            Text(channelPathName)
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
