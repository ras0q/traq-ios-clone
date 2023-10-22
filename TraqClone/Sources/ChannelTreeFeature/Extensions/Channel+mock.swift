import Foundation
import Traq

extension TraqAPI.Channel {
    private static let channelID1 = UUID(uuidString: "11111111-1111-4111-1111-111111111111")

    @Sendable static func mock(_ index: Int) -> TraqAPI.Channel {
        TraqAPI.Channel(
            id: UUID(index),
            parentId: index >= 3 ? UUID(index / 3) : nil,
            archived: Bool.random(),
            force: Bool.random(),
            topic: "topic",
            name: "name\(index)",
            children: (0 ..< 3).map { UUID(3 * index + $0) }
        )
    }
}

extension TraqAPI.DMChannel {
    @Sendable static func mock(_: Int) -> TraqAPI.DMChannel {
        TraqAPI.DMChannel(id: UUID(), userId: UUID())
    }
}
