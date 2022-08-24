import SwiftUI
import Traq

public struct MessageScrollView: View {
    // input parameters
    private let channelId: UUID

    // objects with publisher on change
    @ObservedObject private var messages: Messages = .init()
    @ObservedObject private var userDictionary: UserDictionary = .init()

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

    private final class UserDictionary: ObservableObject {
        @Published fileprivate var data: [UUID: TraqAPI.User] = .init()

        func fetch() {
            TraqAPI.UserAPI.getUsers(includeSuspended: true) { [self] response, error in
                guard error == nil else {
                    print(error!)
                    return
                }

                guard let response = response else {
                    print("response is nil")
                    return
                }

                var dictionary: [UUID: TraqAPI.User] = [:]
                response.forEach { user in
                    dictionary[user.id] = user
                }

                self.data = dictionary
            }
        }

        func getById(_ userId: UUID) -> TraqAPI.User? {
            data[userId]
        }
    }

    public init(channelId: UUID) {
        self.channelId = channelId

        messages.fetch(channelId: channelId)
        userDictionary.fetch()
    }

    public var body: some View {
        ScrollView {
            ForEach(messages.data, id: \.id) { message in
                MessageElementView(
                    message: message,
                    user: userDictionary.getById(message.userId) ?? TraqAPI.User(
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
    static var previews: some View {
        MessageScrollView(channelId: UUID())
    }
}
