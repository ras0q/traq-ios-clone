import Models
import SwiftUI
import Traq

public struct ChannelTreeList<Destination>: View where Destination: View {
    // input parameters
    private let topChannels: [ChannelNode]
    private let destination: (ChannelNode) -> Destination

    // properies managed by SwiftUI
    @State private var openChannelContentView: Bool = false
    @State private var destChannel: ChannelNode = .init(
        id: UUID(),
        parentID: nil,
        name: "dummy",
        children: []
    )

    public init(_ channelDictionary: [UUID: TraqAPI.Channel], destination: @escaping (ChannelNode) -> Destination) {
        topChannels = ChannelNode(from: channelDictionary).children ?? []
        self.destination = destination
    }

    public var body: some View {
        ZStack {
            NavigationLink(
                isActive: $openChannelContentView,
                destination: { destination(destChannel) }
            ) {
                EmptyView()
            }
            .hidden()

            List(topChannels, id: \.id, children: \.children) { channel in
                let imageView = Image(systemName: "number")
                    .fixedSize()
                    .padding(4)

                if (channel.children ?? []).isEmpty {
                    imageView
                } else {
                    imageView
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }

                // Buttonだと行全体に判定がついてしまうため.onTapGestureを使う
                HStack {
                    Text(channel.name)
                    Spacer()
                }
                .contentShape(Rectangle()) // Spacerにも判定をつける
                .onTapGesture {
                    destChannel = channel
                    openChannelContentView = true
                }
            }
        }
    }
}

struct ChannelTreeList_Previews: PreviewProvider {
    private static let mockChannelDictionary: [UUID: TraqAPI.Channel] = {
        let parent1Id = UUID()
        let parent2Id = UUID()
        let child1Id = UUID()
        let child2Id = UUID()
        let grandchild1Id = UUID()

        return [
            parent1Id: .init(
                id: parent1Id,
                parentId: nil,
                archived: false,
                force: false,
                topic: "this is parent1",
                name: "parent1",
                children: [child1Id, child2Id]
            ),
            parent2Id: .init(
                id: parent2Id,
                parentId: nil,
                archived: false,
                force: false,
                topic: "this is parent2",
                name: "parent2",
                children: []
            ),
            child1Id: .init(
                id: child1Id,
                parentId: parent1Id,
                archived: false,
                force: false,
                topic: "this is child1",
                name: "child1",
                children: [grandchild1Id]
            ),
            child2Id: .init(
                id: child2Id,
                parentId: parent1Id,
                archived: false,
                force: false,
                topic: "this is child2",
                name: "child2",
                children: []
            ),
            grandchild1Id: .init(
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

    static var previews: some View {
        NavigationView {
            ChannelTreeList(mockChannelDictionary) { _ in
                EmptyView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("チャンネル")
                    .font(.largeTitle)
                    .bold()
            }
        }
    }
}
