import ComposableArchitecture
import Stores
import SwiftUI
import Traq

public struct MessageScroll: View {
    private let store: StoreOf<ServiceCore>
    private let channelId: UUID

    public init(_ store: StoreOf<ServiceCore>, channelId: UUID) {
        self.store = store
        self.channelId = channelId
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            let messages: [TraqAPI.Message] = (viewStore.message.channelMesssages[channelId] ?? [])
                .sorted { $0.createdAt < $1.createdAt }
            let userDictionary: [UUID: TraqAPI.User] = viewStore.user.userDictionary

            ScrollView {
                LazyVStack {
                    Text("")
                        .onAppear {
                            guard !viewStore.state.message.isFetchingMessages else { return }
                            viewStore.send(
                                .message(
                                    .fetchMessages(
                                        channelId: channelId,
                                        limit: nil,
                                        offset: nil,
                                        since: nil,
                                        until: messages.first?.createdAt,
                                        inclusive: nil
                                    )
                                )
                            )
                        }
                    ForEach(messages, id: \.id) { message in
                        MessageElement(
                            message: message,
                            user: userDictionary[message.userId] ?? TraqAPI.User(
                                id: message.userId,
                                name: "unknown",
                                displayName: "unknown",
                                iconFileId: UUID(),
                                bot: false,
                                state: .active,
                                updatedAt: Date()
                            )
                        )
                    }
                    Text("")
                        .onAppear {
                            guard !viewStore.state.message.isFetchingMessages else { return }
                            viewStore.send(
                                .message(
                                    .fetchMessages(
                                        channelId: channelId,
                                        limit: nil,
                                        offset: nil,
                                        since: messages.last?.createdAt,
                                        until: nil,
                                        inclusive: nil
                                    )
                                )
                            )
                        }
                }
            }
        }
    }
}

struct MessageScroll_Previews: PreviewProvider {
    private static let user1Id: UUID = .init()
    private static let user2Id: UUID = .init()
    private static let channelId: UUID = .init()

    static var previews: some View {
        MessageScroll(.defaultStore, channelId: UUID())
    }
}
