import Models
import SwiftUI
import Traq

public struct ChannelContentHeaderView: View {
    private let channel: ChannelNode
    private let channelPath: String

    public init(_ channel: ChannelNode, _ dictionary: [UUID: TraqAPI.Channel]) {
        self.channel = channel

        var revPaths: [String] = [channel.name]
        var tmp: TraqAPI.Channel = .init(
            id: channel.id,
            parentId: channel.parentId,
            archived: .init(),
            force: .init(),
            topic: .init(),
            name: .init(),
            children: .init()
        )
        while tmp.parentId != nil {
            guard let parent = dictionary[tmp.parentId!] else {
                fatalError("cannot resolve channnel tree")
            }

            revPaths.append(parent.name)
            tmp = parent
        }

        channelPath = revPaths.reversed().joined(separator: "/")
    }

    public var body: some View {
        HStack {
            Text("#\(channelPath)")
                .font(.title)
                .bold()
            Divider().background(Color.gray)
            Text(channel.topic)
            Spacer()
            Button(action: {}, label: { Image(systemName: "phone") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "bell") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "star") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "ellipsis") }).foregroundColor(.black)
        }
        .fixedSize()
        .padding()
        .overlay(
            Rectangle().frame(height: 1).foregroundColor(.gray),
            alignment: .bottom
        )
        .navigationTitle("#\(channelPath)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChannelContentHeaderView_Previews: PreviewProvider {
    private static let channelId = UUID()
    private static let parentId = UUID()

    static var previews: some View {
        ChannelContentHeaderView(
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
