import ComposableArchitecture
import Models
import Stores
import SwiftUI
import Traq

public struct ChannelContentView: View {
    private let store: StoreOf<ServiceCore>
    private let channel: TraqAPI.Channel
    private let channelPath: String

    public init(store: StoreOf<ServiceCore>, channel: TraqAPI.Channel) {
        self.store = store
        self.channel = channel
        channelPath = "# " + ViewStore(store).channel.channelDictionary.getLongPath(from: channel.id)
    }

    @Environment(\.dismiss) var dismiss
    public var body: some View {
        WithViewStore(store) { _ in
            VStack {
                MessageScroll(store, channelId: channel.id)
                MessageInput(needAlert: channel.force)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.blue)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Text(channelPath)
                        .font(.title2)
                        .bold()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {} label: {
                            Text("Qallを開始")
                            Image(systemName: "phone")
                        }
                        Button {} label: {
                            Text("通知設定")
                            Image(systemName: "bell")
                        }
                        Button {} label: {
                            Text("お気に入り")
                            Image(systemName: "star")
                        }
                        Button {} label: {
                            Text("子チャンネルを作成")
                            Image(systemName: "number")
                        }
                        Button {} label: {
                            Text("チャンネル内検索")
                            Image(systemName: "magnifyingglass")
                        }
                        Button {} label: {
                            Text("チャンネルリンクをコピー")
                            Image(systemName: "link")
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                }
            }
        }
    }
}

struct ChannelContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentView(
            store: .defaultStore,
            channel: .init(
                id: UUID(),
                parentId: nil,
                archived: false,
                force: false,
                topic: "トピック",
                name: "ch1",
                children: [UUID(), UUID()]
            )
        )
    }
}
