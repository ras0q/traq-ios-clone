import SwiftUI
import Traq

public struct MessageElement: View {
    private let dateFormatter: DateFormatter
    private let message: TraqAPI.Message
    private let user: TraqAPI.User
    private let stamps: [TraqAPI.Stamp]

    public init(message: TraqAPI.Message, user: TraqAPI.User, stamps: [TraqAPI.Stamp]) {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "HH:mm"

        self.message = message
        self.user = user
        self.stamps = stamps
    }

    public var body: some View {
        HStack(alignment: .top) {
            UserIcon(iconFileId: user.iconFileId)
                .frame(width: 40, height: 40, alignment: .leading)
            VStack {
                HStack {
                    Text("\(user.displayName)")
                        .bold()
                    Button(
                        action: {},
                        label: {
                            Text("[00B]")
                        }
                    )
                    .foregroundColor(.black)
                    Text("@\(user.name) \(dateFormatter.string(from: message.updatedAt))")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: 20, alignment: .leading)
                Markdown(message.content, stamps: stamps)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
}

public extension MessageElement {
    static let sampleMessages: [TraqAPI.Message] = {
        var messages: [TraqAPI.Message] = []
        for _ in 0 ... 10 {
            messages.append(TraqAPI.Message(
                id: UUID(),
                userId: UUID(),
                channelId: UUID(),
                content: "this is a content.",
                createdAt: Date(),
                updatedAt: Date(),
                pinned: false,
                stamps: [],
                threadId: nil
            ))
        }
        return messages
    }()
}

struct MessageElement_Previews: PreviewProvider {
    static var previews: some View {
        MessageElement(
            message: TraqAPI.Message(
                id: UUID(),
                userId: UUID(),
                channelId: UUID(),
                content: "this is a content.",
                createdAt: Date(),
                updatedAt: Date(),
                pinned: false,
                stamps: [],
                threadId: nil
            ),
            user: TraqAPI.User(
                id: UUID(),
                name: "unknown",
                displayName: "unknown",
                iconFileId: UUID(),
                bot: false,
                state: .active,
                updatedAt: Date()
            ),
            stamps: []
        )
    }
}
