import SDWebImageSwiftUI
import SwiftUI
import Traq

public struct MessageElement: View {
    private let dateFormatter: DateFormatter
    private let message: TraqAPI.Message
    private let user: TraqAPI.User

    public init(message: TraqAPI.Message, user: TraqAPI.User) {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "HH:mm"

        self.message = message
        self.user = user
    }

    public var body: some View {
        HStack(alignment: .top) {
            WebImage(url: URL(string: "\(TraqAPI.basePath)/public/icon/\(user.name)"), isAnimating: .constant(true))
                .onFailure { error in
                    print(error.localizedDescription)
                }
                .resizable()
                .placeholder(Image(systemName: "person.crop.circle"))
                .indicator(.activity) // Activity Indicator
                .clipShape(Circle())
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
                Text(message.content)
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
            )
        )
    }
}
