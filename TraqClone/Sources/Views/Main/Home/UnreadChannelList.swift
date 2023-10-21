import ComposableArchitecture
import Stores
import SwiftUI
import Traq

struct UnreadChannelList: View {
    private let store: StoreOf<ServiceCore>
    private let unreadChannels: [TraqAPI.UnreadChannel]
    private let channelDictionary: [UUID: TraqAPI.Channel]
    @Binding private var channelPath: [TraqAPI.Channel]

    public init(
        store: StoreOf<ServiceCore>,
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
        WithViewStore(store, observe: { $0 }) { viewStore in
            List(unreadChannels, id: \.channelId) { unreadChannel in
                if let channel = channelDictionary[unreadChannel.channelId] {
                    Button {
                        viewStore.send(.message(.fetchMessages(channelId: unreadChannel.channelId)))
                        channelPath.append(channel)
                    } label: {
                        HStack {
                            Image(systemName: "number")
                            Text(channelDictionary.getLongPath(from: channel.id))
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
