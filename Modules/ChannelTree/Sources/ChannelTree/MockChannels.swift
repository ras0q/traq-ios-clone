import Foundation
import OpenAPIClient

public extension ChannelNode {
    static let mockChannels: [Channel] = {
        let parent1Id = UUID()
        let parent2Id = UUID()
        let child1Id = UUID()
        let child2Id = UUID()
        let grandchild1Id = UUID()

        return [
            .init(
                id: parent1Id,
                parentId: nil,
                archived: false,
                force: false,
                topic: "this is parent1",
                name: "parent1",
                children: [child1Id, child2Id]
            ),
            .init(
                id: parent2Id,
                parentId: nil,
                archived: false,
                force: false,
                topic: "this is parent2",
                name: "parent2",
                children: []
            ),
            .init(
                id: child1Id,
                parentId: parent1Id,
                archived: false,
                force: false,
                topic: "this is child1",
                name: "child1",
                children: [grandchild1Id]
            ),
            .init(
                id: child2Id,
                parentId: parent1Id,
                archived: false,
                force: false,
                topic: "this is child2",
                name: "child2",
                children: []
            ),
            .init(
                id: grandchild1Id,
                parentId: child1Id,
                archived: false,
                force: false,
                topic: "this is grandchild1",
                name: "grandchild1",
                children: []
            ),
        ]
    }()

    static let mockTopChannels: [ChannelNode] = ChannelNode(channels: mockChannels).children!
}
