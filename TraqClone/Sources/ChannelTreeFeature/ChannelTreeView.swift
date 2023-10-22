import APIClient
import ComposableArchitecture
import SwiftUI
import Traq

public struct ChannelTree: Reducer {
    struct ChannelRecursive: Identifiable, Equatable {
        var id: UUID { base.id }
        let base: TraqAPI.Channel
        let children: [ChannelRecursive]?

        init(base: TraqAPI.Channel, children: [ChannelRecursive]?) {
            self.base = base
            self.children = children
        }

        init?(channels: [TraqAPI.Channel], rootId: UUID? = nil) {
            func getDescendants(parentId: UUID?) -> [ChannelRecursive]? {
                let children = channels.filter { $0.parentId == parentId }
                return children.map {
                    ChannelRecursive(base: $0, children: getDescendants(parentId: $0.id))
                }
            }

            base = channels.first { $0.id == rootId } ?? .mock(0)
            children = getDescendants(parentId: rootId)
        }
    }

    public struct State: Equatable {
        var channels: [ChannelRecursive] = []
        var isLoading: Bool = false

        public init() {}
    }

    public enum Action: Equatable {
        case onAppear
        case fetchChannelsResponse(TaskResult<[TraqAPI.Channel]>)
    }

    public init() {}

    @Dependency(\.channelAPI) private var channelAPI

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(.fetchChannelsResponse(TaskResult {
                        try await channelAPI.getChannels(false)._public
                    }))
                }
            case let .fetchChannelsResponse(result):
                state.isLoading = false
                switch result {
                case let .success(response):
                    state.channels = ChannelRecursive(channels: response)?.children ?? []
                case let .failure(error):
                    print(error.localizedDescription)
                }
                return .none
            }
        }
    }
}

public struct ChannelTreeView: View {
    let store: StoreOf<ChannelTree>

    public init(store: StoreOf<ChannelTree>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            Group {
                List(viewStore.channels, id: \.id, children: \.children) {
                    ChannelTreeNodeView(
                        store: .init(
                            initialState: ChannelTreeNode.State(channel: $0.base)
                        ) {
                            ChannelTreeNode()
                        }
                    )
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}

#Preview {
    ChannelTreeView(
        store: .init(initialState: ChannelTree.State()) {
            ChannelTree()
                ._printChanges()
        } withDependencies: {
            $0.channelAPI.getChannels = { includeDM in
                try await Task.sleep(for: .seconds(0.5))
                return TraqAPI.ChannelList(
                    _public: (0 ..< 10).map { .mock($0) },
                    dm: includeDM ? (0 ..< 5).map { .mock($0) } : nil
                )
            }
        }
    )
}
