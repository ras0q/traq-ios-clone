import Foundation
import Traq

public extension Array where Element == TraqAPI.UnreadChannel {
    static let mock: [TraqAPI.UnreadChannel] = {
        let channelsMock: [TraqAPI.Channel] = .mock
        return [
            .init(channelId: channelsMock[0].id, count: 1, noticeable: false, since: Date(), updatedAt: Date()),
            .init(channelId: channelsMock[1].id, count: 99, noticeable: false, since: Date(), updatedAt: Date()),
            .init(channelId: channelsMock[2].id, count: 100, noticeable: false, since: Date(), updatedAt: Date()),
            .init(channelId: channelsMock[3].id, count: 5, noticeable: true, since: Date(), updatedAt: Date()),
        ]
    }()
}
