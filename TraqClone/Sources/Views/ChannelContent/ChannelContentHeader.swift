import Models
import SwiftUI
import Traq

public struct ChannelContentHeader: View {
    private let channel: TraqAPI.Channel
    private let shortChannelPath: String

    public init(_ channel: TraqAPI.Channel, _ dictionary: [UUID: TraqAPI.Channel]) {
        self.channel = channel
        shortChannelPath = dictionary.getShortPath(from: channel.id)
    }

    public var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(shortChannelPath)
                    .font(.title)
                    .bold()
                Text(channel.topic)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {}, label: { Image(systemName: "phone") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "bell") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "star") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "ellipsis") }).foregroundColor(.black)
        }
        .frame(height: 50)
        .padding()
        .overlay(
            Rectangle().frame(height: 1).foregroundColor(.gray),
            alignment: .bottom
        )
        .navigationTitle(shortChannelPath)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChannelContentHeader_Previews: PreviewProvider {
    private static let channelId = UUID()
    private static let parentId = UUID()

    static var previews: some View {
        ChannelContentHeader(
            TraqAPI.Channel(
                id: channelId,
                parentId: parentId,
                archived: false,
                force: false,
                topic: "preview topic",
                name: "preview",
                children: []
            ),
            [
                channelId: .init(
                    id: channelId,
                    parentId: parentId,
                    archived: false,
                    force: false,
                    topic: "",
                    name: "preview",
                    children: []
                ),
                parentId: .init(
                    id: parentId,
                    parentId: nil,
                    archived: false,
                    force: false,
                    topic: "",
                    name: "parent",
                    children: [channelId]
                ),
            ]
        )
    }
}
