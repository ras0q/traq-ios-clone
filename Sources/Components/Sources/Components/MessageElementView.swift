import OpenAPIClient
import SwiftUI

public struct MessageElementView: View {
    private let dateFormatter: DateFormatter
    private let message: Message

    public init(message: Message) {
        dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "HH:mm"

        self.message = message
    }

    public var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .frame(width: 40, height: 40, alignment: .leading)
            VStack {
                HStack {
                    Text("ユーザー1")
                        .bold()
                    Button(
                        action: {},
                        label: {
                            Text("[00B]")
                        }
                    )
                    .foregroundColor(.black)
                    Text("@user1 \(dateFormatter.string(from: message.updatedAt))")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Text(message.content)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
    }
}

public extension MessageElementView {
    static let sampleMessages: [Message] = {
        var messages: [Message] = []
        for _ in 0 ... 10 {
            messages.append(Message(
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

struct MessageElementView_Previews: PreviewProvider {
    static var previews: some View {
        MessageElementView(message: Message(
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
}
