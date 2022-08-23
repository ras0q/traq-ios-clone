import Repositories
import SwiftUI
import Traq

public struct MessageScrollView: View {
    private final class Messages: ObservableObject {
        @Published fileprivate var data: [TraqAPI.Message] = .init()

        init(_ messages: [TraqAPI.Message]) {
            data = messages
        }
    }

    private let channelRepository: ChannelRepository = ChannelRepositoryImpl()
    private let channelId: UUID
    @ObservedObject private var messages: Messages = .init(MessageElementView.sampleMessages)

    public init(channelId: UUID) {
        self.channelId = channelId

        channelRepository.fetchChannelMessages(channelId: channelId, options: nil) { [self] messages in
            self.messages.data = messages.reversed()
        }
    }

    public var body: some View {
        ScrollView {
            ForEach(messages.data, id: \.id) { message in
                MessageElementView(message: message)
            }
        }
    }
}

struct MessageScrollView_Previews: PreviewProvider {
    static var previews: some View {
        MessageScrollView(channelId: UUID())
    }
}
