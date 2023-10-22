import ComposableArchitecture
import SwiftUI
import Traq

public struct ChannelTreeNode: Reducer {
    public struct State: Equatable, Identifiable {
        public var id: UUID { channel.id }
        let channel: TraqAPI.Channel
    }

    public enum Action: Equatable {
        case onTapped
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onTapped:
                return .none
            }
        }
    }
}

struct ChannelTreeNodeView: View {
    let store: StoreOf<ChannelTreeNode>

    init(store: StoreOf<ChannelTreeNode>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack {
                hashImageView(haveChildren: viewStore.channel.children.count > 0)

                // Buttonだと行全体に判定がついてしまうため.onTapGestureを使う
                HStack {
                    Text(viewStore.channel.name)
                    Spacer()
                }
                .contentShape(Rectangle()) // Spacerにも判定をつける
                .onTapGesture {
                    viewStore.send(.onTapped)
                }
            }
        }
    }

    private func hashImageView(haveChildren: Bool) -> some View {
        HStack {
            let imageView = Image(systemName: "number")
                .fixedSize()
                .padding(4)

            if haveChildren {
                imageView
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.black, lineWidth: 2)
                    )
            } else {
                imageView
            }
        }
    }
}

#Preview {
    ForEach(0 ..< 5) { index in
        ChannelTreeNodeView(store: .init(
            initialState: ChannelTreeNode.State(channel: .mock(index))
        ) {
            ChannelTreeNode()
        })
    }
}
