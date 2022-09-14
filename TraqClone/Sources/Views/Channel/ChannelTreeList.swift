import ComposableArchitecture
import Models
import Stores
import SwiftUI
import Traq

public struct ChannelTreeList: View {
    // input parameters
    private let store: ServiceCore.Store
    private let topChannels: [ChannelNode]

    // properies managed by SwiftUI
    @State private var openChannelContentView: Bool = false
    @State private var destChannel: TraqAPI.Channel = .init(
        id: UUID(),
        parentId: nil,
        archived: false,
        force: false,
        topic: "dummy topic",
        name: "dummy",
        children: []
    )

    public init(store: ServiceCore.Store, topChannels: [ChannelNode]) {
        self.store = store
        self.topChannels = topChannels
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            ZStack {
                NavigationLink(
                    isActive: $openChannelContentView,
                    destination: {
                        ChannelContentView(store: store, channel: destChannel)
                    }
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
                        viewStore.send(.message(.fetchMessages(channelId: channel.id)))

                        destChannel = channel.toTraqChannel()
                        openChannelContentView = true
                    }
                }
            }
        }
    }
}

struct ChannelTreeList_Previews: PreviewProvider {
    private static let mockTopChannels: [ChannelNode] = {
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
                children: [
                    .init(
                        id: child1Id,
                        parentId: parent1Id,
                        archived: false,
                        force: false,
                        topic: "this is child1",
                        name: "child1",
                        children: [
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
                ]
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
        ]
    }()

    static var previews: some View {
        NavigationView {
            ChannelTreeList(
                store: .defaultStore,
                topChannels: mockTopChannels
            )
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
