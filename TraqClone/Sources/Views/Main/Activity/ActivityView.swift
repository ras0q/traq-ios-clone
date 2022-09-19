import ComposableArchitecture
import Stores
import SwiftUI
import Traq

public struct ActivityView: View {
    private let store: ServiceCore.Store

    public init(store: ServiceCore.Store) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List(viewStore.message.recentMessages, id: \.id) { message in
                    Section {
                        NavigationLink {
                            ChannelContentView(
                                store: store,
                                channel: viewStore.channel.channelDictionary[message.channelId]!
                            )
                        } label: {
                            messagePreviewElement(
                                message: message,
                                user: viewStore.user.userDictionary[message.userId]!,
                                channelPath: viewStore.channel.channelDictionary.getLongPath(from: message.channelId)
                            )
                        }
                    }
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

            Markdown(message.content)
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView(store: .defaultStore)
    }
}
