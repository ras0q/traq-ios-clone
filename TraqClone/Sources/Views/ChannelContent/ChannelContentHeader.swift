import Models
import SwiftUI
import Traq

public struct ChannelContentHeader: View {
    private let channel: ChannelNode
    private let shortChannelPath: String

    public init(_ channel: ChannelNode, _ dictionary: [UUID: TraqAPI.Channel]) {
        self.channel = channel

        var parentPaths: [String] = [] // [parent,grandParent,...]の順
        var tmpChannel: TraqAPI.Channel = .init(
            id: channel.id,
            parentId: channel.parentId,
            archived: .init(),
            force: .init(),
            topic: .init(),
            name: .init(),
            children: .init()
        )
        while tmpChannel.parentId != nil {
            guard let parent = dictionary[tmpChannel.parentId!] else {
                fatalError("cannot resolve channnel tree")
            }

            parentPaths.append(parent.name)
            tmpChannel = parent
        }

        let shortParentPath = parentPaths
            .map { $0.prefix(1) }
            .reversed()
            .joined(separator: "/")
        shortChannelPath = parentPaths.count > 0
            ? "#\(shortParentPath)/\(channel.name)"
            : "#\(channel.name)"
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
            ChannelNode(
                id: channelId,
                parentID: parentId,
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
