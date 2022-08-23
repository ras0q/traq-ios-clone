import Repositories
import SwiftUI
import Traq

public struct MessageScrollView: View {
    private final class Messages: ObservableObject {
        @Published fileprivate var data: [TraqAPI.Message] = .init()

        init(_ messages: [TraqAPI.Message]) {
            data = messages
        }
    }

    private final class UserDictionary: ObservableObject {
        @Published fileprivate var data: [UUID: TraqAPI.User] = .init()

        init(_ users: [UUID: TraqAPI.User]) {
            data = users
        }
    }

    private let channelRepository: ChannelRepository = ChannelRepositoryImpl()
    private let userRepository: UserRepository = UserRepositoryImpl()
    private let channelId: UUID
    @ObservedObject private var messages: Messages = .init(MessageElementView.sampleMessages)
    private var userDictionary: UserDictionary = .init([:])

    public init(channelId: UUID) {
        self.channelId = channelId

        channelRepository.fetchChannelMessages(channelId: channelId, options: nil) { [self] messages in
            self.messages.data = messages.reversed()
        }

        userRepository.fetchUsers(options: nil) { [self] users in
            var userDictionary: [UUID: TraqAPI.User] = [:]

            users.forEach { user in
                userDictionary[user.id] = user
            }

            self.userDictionary.data = userDictionary
        }
    }

    public var body: some View {
        ScrollView {
            ForEach(messages.data, id: \.id) { message in
                MessageElementView(message: message, user: userDictionary.data[message.userId] ?? TraqAPI.User(
                    id: UUID(),
                    name: "unknown",
                    displayName: "unknown",
                    iconFileId: UUID(),
                    bot: false,
                    state: .active,
                    updatedAt: Date()
                ))
            }
        }
    }
}

struct MessageScrollView_Previews: PreviewProvider {
    static var previews: some View {
        MessageScrollView(channelId: UUID())
    }
}
