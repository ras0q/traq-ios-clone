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

    public init(id: UUID, parentId: UUID?, archived: Bool = false, force: Bool = false, topic: String = "", name: String, children: [ChannelNode]?) {
        self.id = id
        self.parentId = parentId
        self.archived = archived
        self.force = force
        self.topic = topic
        self.name = name
        self.children = children
    }

    public init?(rootId: UUID, dictionary: [UUID: TraqAPI.Channel], includeArchived: Bool) {
        guard let root: TraqAPI.Channel = dictionary[rootId] else { return nil }

        id = root.id
        parentId = root.parentId
        archived = root.archived
        force = root.force
        topic = root.topic
        name = root.name
        children = getDescendants(
            childIds: root.children,
            dictionary: dictionary,
            includeArchived: includeArchived
        )
    }

    public init(from channelDictionary: [UUID: TraqAPI.Channel]) {
        id = UUID()
        parentId = nil
        archived = false
        force = false
        topic = ""
        name = "dummy-root"

        let topChannelIDs = channelDictionary.values
            .filter { $0.parentId == nil && !$0.archived }
            .map(\.id)

        children = getDescendants(
            childIds: topChannelIDs,
            dictionary: channelDictionary,
            includeArchived: false
        )
    }

    private func getDescendants(
        childIds: [UUID],
        dictionary: [UUID: TraqAPI.Channel],
        includeArchived: Bool
    ) -> [ChannelNode]? {
        childIds.map { childId -> ChannelNode in
            guard let child = dictionary[childId] else {
                fatalError("cannot resolve channnel tree")
            }

            return ChannelNode(
                id: child.id,
                parentId: child.parentId,
                archived: child.archived,
                force: child.force,
                topic: child.topic,
                name: child.name,
                children: getDescendants(
                    childIds: child.children,
                    dictionary: dictionary,
                    includeArchived: includeArchived
                )
            )
        }
        .filter { includeArchived || !$0.archived }
        .sorted { $0.name.lowercased() < $1.name.lowercased() }
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
