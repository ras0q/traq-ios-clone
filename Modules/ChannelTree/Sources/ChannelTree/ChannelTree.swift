import Foundation
import OpenAPIClient

public final class ChannelTree: Identifiable {
    public let id: UUID
    public let parentId: UUID?
    public let archived: Bool
    public let force: Bool
    public let topic: String
    public let name: String
    public var children: [ChannelTree]?

    public init(id: UUID, parentID: UUID?, archived: Bool = false, force: Bool = false, topic: String = "", name: String, children: [ChannelTree]?) {
        self.id = id
        parentId = parentID
        self.archived = archived
        self.force = force
        self.topic = topic
        self.name = name
        self.children = children
    }

    public init(channels: [Channel]) {
        id = UUID()
        parentId = nil
        archived = false
        force = false
        topic = ""
        name = "dummy-root"

        // get-children process

        let channelDictionary = channels.reduce([UUID: Channel]()) { dic, channel in
            var resultDic = dic
            resultDic[channel.id] = channel
            return resultDic
        }

        var getChildrenRecursive: (([UUID]) -> [ChannelTree]?)!
        getChildrenRecursive = { childIDs in
            childIDs.map { childID in
                guard let child = channelDictionary[childID] else {
                    fatalError("cannot resolve channnel tree")
                }
                return ChannelTree(
                    id: child.id,
                    parentID: child.parentId,
                    archived: child.archived,
                    force: child.force,
                    topic: child.topic,
                    name: child.name,
                    children: getChildrenRecursive(child.children)
                )
            }
        }

        let topChannelIDs = channels.filter { $0.parentId == nil }.map(\.id)
        children = getChildrenRecursive(topChannelIDs)
    }
}

public extension ChannelTree {
    static let sampleChannelTree = { () -> ChannelTree in
        let rootId = UUID()
        let parent1Id = UUID()
        let parent2Id = UUID()
        let child1Id = UUID()
        let child2Id = UUID()
        let grandchild1Id = UUID()

        return ChannelTree(
            id: rootId,
            parentID: nil,
            name: "dummy-root",
            children: [
                ChannelTree(
                    id: parent1Id,
                    parentID: rootId,
                    name: "parent1",
                    children: [
                        ChannelTree(
                            id: child1Id,
                            parentID: parent1Id,
                            name: "child1",
                            children: [
                                ChannelTree(
                                    id: grandchild1Id,
                                    parentID: child1Id,
                                    name: "grandchild1",
                                    children: nil
                                ),
                            ]
                        ),
                        ChannelTree(
                            id: child2Id,
                            parentID: parent1Id,
                            name: "child2",
                            children: nil
                        ),
                    ]
                ),
                ChannelTree(
                    id: parent2Id,
                    parentID: rootId,
                    name: "parent2",
                    children: nil
                ),
            ]
        )
    }()
}
