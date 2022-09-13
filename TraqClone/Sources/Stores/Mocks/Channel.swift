import Foundation
import Traq

public extension Array where Element == TraqAPI.Channel {
    static let mock: [TraqAPI.Channel] = {
        let ids: [UUID] = .init(repeating: UUID(), count: 10).map { _ in UUID() }
        return [
            .init(id: ids[0], parentId: nil, archived: false, force: false, topic: "トピック", name: "ch1", children: [ids[1], ids[2]]),
            .init(id: ids[1], parentId: ids[0], archived: false, force: false, topic: "子チャンネル", name: "ch1-1", children: [ids[3]]),
            .init(id: ids[2], parentId: ids[1], archived: false, force: false, topic: "", name: "ch1-1-1", children: []),
            .init(id: ids[3], parentId: ids[0], archived: false, force: false, topic: "", name: "ch1-2", children: []),
            .init(id: ids[4], parentId: nil, archived: false, force: false, topic: "子チャンネルなし", name: "ch2", children: []),
            .init(id: ids[5], parentId: nil, archived: true, force: false, topic: "アーカイブチャンネル", name: "ch3", children: [ids[6]]),
            .init(id: ids[6], parentId: ids[6], archived: false, force: false, topic: "アーカイブチャンネル下のアクティブチャンネル", name: "ch3-1", children: []),
            .init(id: ids[7], parentId: ids[6], archived: true, force: false, topic: "アーカイブチャンネル下のアーカイブチャンネル", name: "ch3-2", children: []),
        ]
    }()
}

public extension TraqAPI.Channel {
    static let mock: TraqAPI.Channel = [TraqAPI.Channel].mock[0]
}
