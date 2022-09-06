import SwiftUI
import Traq

public final class ChannelNode: Identifiable {
    public let id: UUID
    public let parentId: UUID?
    public let archived: Bool
    public let force: Bool
    public let topic: String
    public let name: String
    public var children: [ChannelNode]?

    public init(id: UUID, parentID: UUID?, archived: Bool = false, force: Bool = false, topic: String = "", name: String, children: [ChannelNode]?) {
        self.id = id
        parentId = parentID
        self.archived = archived
        self.force = force
        self.topic = topic
        self.name = name
        self.children = children
    }

    public init(from channelDictionary: [UUID: TraqAPI.Channel]) {
        id = UUID()
        parentId = nil
        archived = false
        force = false
        topic = ""
        name = "dummy-root"

        var getChildrenRecursive: (([UUID]) -> [ChannelNode]?)!
        getChildrenRecursive = { childIDs in
            childIDs.map { childID -> ChannelNode in
                guard let child = channelDictionary[childID] else {
                    fatalError("cannot resolve channnel tree")
                }

                return ChannelNode(
                    id: child.id,
                    parentID: child.parentId,
                    archived: child.archived,
                    force: child.force,
                    topic: child.topic,
                    name: child.name,
                    children: getChildrenRecursive(child.children)
                )
            }
            .filter { !$0.archived }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
        }

        let topChannelIDs = channelDictionary.values
            .filter { $0.parentId == nil && !$0.archived }
            .map(\.id)

        children = getChildrenRecursive(topChannelIDs)
    }

    public func toTraqChannel() -> TraqAPI.Channel {
        TraqAPI.Channel(
            id: id,
            parentId: parentId,
            archived: archived,
            force: force,
            topic: topic,
            name: name,
            children: children?.map(\.id) ?? []
        )
    }
}
