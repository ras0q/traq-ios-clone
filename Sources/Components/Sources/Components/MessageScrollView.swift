import SwiftUI
import Traq

public struct MessageScrollView: View {
    // input parameters
    private let channelId: UUID
    private let userDictionary: [UUID: TraqAPI.User]

    // objects with publisher on change
    @ObservedObject private var messages: Messages = .init()

    private final class Messages: ObservableObject {
        @Published fileprivate var data: [TraqAPI.Message] = .init()

        func fetch(channelId: UUID) {
            TraqAPI.ChannelAPI.getMessages(channelId: channelId) { [self] response, error in
                guard error == nil else {
                    print(error!)
                    return
                }

                guard let response = response else {
                    print("response is nil")
                    return
                }

                self.data = response
            }
        }
    }

    public init(_ channelId: UUID, _ userDictionary: [UUID: TraqAPI.User]) {
        self.channelId = channelId
        self.userDictionary = userDictionary

        messages.fetch(channelId: channelId)
    }

    public var body: some View {
        ScrollView {
            ForEach(messages.data, id: \.id) { message in
                MessageElementView(
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

struct MessageScrollView_Previews: PreviewProvider {
    private static let user1Id: UUID = .init()
    private static let user2Id: UUID = .init()

    static var previews: some View {
        MessageScrollView(UUID(), [
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
        ])
    }
}
