import ComposableArchitecture
import Stores
import SwiftUI
import Traq

public struct ActivityView: View {
    private let store: ServiceCore.Store

    public init(store: ServiceCore.Store) {
        self.store = store
    }

    @State private var channelPath: [UUID] = []

    public var body: some View {
        WithViewStore(store) { viewStore in
            let userDictionary = viewStore.user.userDictionary
            let channelDictionary = viewStore.channel.channelDictionary

            NavigationStack(path: $channelPath) {
                List(viewStore.message.recentMessages, id: \.id) { message in
                    Section {
                        Button {
                            channelPath.append(message.channelId)
                        } label: {
                            messagePreviewElement(
                                message: message,
                                user: userDictionary[message.userId]!,
                                channelPath: channelDictionary.getLongPath(from: message.channelId)
                            )
                            .foregroundColor(.black)
                        }
                    }
                }
                .navigationDestination(for: UUID.self) { channelId in
                    ChannelContentView(
                        store: store,
                        channel: channelDictionary[channelId]!
                    )
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("アクティビティ")
                            .font(.largeTitle)
                            .bold()
                    }
                }
            }
        }
    }

    private func messagePreviewElement(message: TraqAPI.Message, user: TraqAPI.User, channelPath: String) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 1) {
                UserIcon(userName: user.name)
                    .frame(width: 30, height: 30)
                Text(user.displayName)
            }

            Divider()

            HStack {
                Image(systemName: "number")
                Text(channelPath)
            }
            .foregroundColor(.gray)

            Markdown(message.markdownContent)
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(store: .defaultStore)
    }
}
