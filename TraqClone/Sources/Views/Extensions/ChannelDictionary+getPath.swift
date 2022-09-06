import Foundation
import Traq

extension Dictionary where Key == UUID, Value == TraqAPI.Channel {
    func getLongPath(from channelId: UUID) -> String {
        let paths = getPathArray(from: channelId)

        return "#" + paths
            .reversed()
            .joined(separator: "/")
    }

    func getShortPath(from channelId: UUID) -> String {
        let paths = getPathArray(from: channelId)

        return "#" + paths
            .enumerated()
            .map { $0.offset == 0 ? $0.element : String($0.element.prefix(1)) }
            .reversed()
            .joined(separator: "/")
    }

    private func getPathArray(from channelId: UUID) -> [String] {
        guard let channel = self[channelId] else { return [] }

        var channelPaths: [String] = [channel.name] // [me,parent,grandParent,...]の順
        var tmpChannel: TraqAPI.Channel = .init(
            id: channel.id,
            parentId: channel.parentId,
            archived: .init(),
            force: .init(),
            topic: .init(),
            name: .init(),
            children: .init()
        )

        while tmpChannel.parentId != nil {
            guard let parent = self[tmpChannel.parentId!] else {
                fatalError("cannot resolve channnel tree")
            }

            channelPaths.append(parent.name)
            tmpChannel = parent
        }

        return channelPaths
    }
}
