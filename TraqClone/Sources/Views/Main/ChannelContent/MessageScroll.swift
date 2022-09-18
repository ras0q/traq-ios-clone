import SwiftUI
import Traq

public struct MessageScroll: View {
    private let messages: [TraqAPI.Message]
    private let userDictionary: [UUID: TraqAPI.User]

    public init(_ messages: [TraqAPI.Message], _ userDictionary: [UUID: TraqAPI.User]) {
        self.messages = messages
        self.userDictionary = userDictionary
    }

    public var body: some View {
        ScrollView {
            LazyVStack {
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
            }
        }
    }
}

struct MessageScroll_Previews: PreviewProvider {
    private static let user1Id: UUID = .init()
    private static let user2Id: UUID = .init()
    private static let channelId: UUID = .init()

    static var previews: some View {
        MessageScroll(
            [
                .init(id: UUID(), userId: user1Id, channelId: channelId, content: "これはメッセージです", createdAt: Date(), updatedAt: Date(), pinned: false, stamps: [], threadId: nil),
                .init(id: UUID(), userId: user1Id, channelId: channelId, content: "ピン留めされたメッセージ", createdAt: Date(), updatedAt: Date(), pinned: true, stamps: [], threadId: nil),
            ],
            [
                user1Id: .init(
                    id: UUID(),
                    name: "user1",
                    displayName: "ユーザー1",
                    iconFileId: UUID(),
                    bot: false,
                    state: .active,
                    updatedAt: Date()
                ),
                user2Id: .init(
                    id: UUID(),
                    name: "user2",
                    displayName: "ユーザー2",
                    iconFileId: UUID(),
                    bot: false,
                    state: .active,
                    updatedAt: Date()
                ),
            ]
        )
    }
}
