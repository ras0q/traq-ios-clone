import ComposableArchitecture
import Models
import Stores
import SwiftUI
import Traq

public struct WithNavigationLinkToChannelContent<Label>: View where Label: View {
    private let store: ServiceCore.Store
    private let label: (Binding<Bool>, Binding<TraqAPI.Channel>) -> Label

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

    public init(
        store: ServiceCore.Store,
        label: @escaping (Binding<Bool>, Binding<TraqAPI.Channel>) -> Label
    ) {
        self.store = store
        self.label = label
    }

    public var body: some View {
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

            label($openChannelContentView, $destChannel)
        }
    }
}

struct ChannelTreeNavigationList_Previews: PreviewProvider {
    private static let store: ServiceCore.Store = .defaultStore
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
            WithNavigationLinkToChannelContent(store: store) { openChannelContentView, destChannel in
                ChannelTreeList(
                    store: store,
                    channels: mockTopChannels,
                    openChannelContentView: openChannelContentView,
                    destChannel: destChannel
                )
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
