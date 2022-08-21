import ChannelTree
import SwiftUI

struct ChannelContentHeader: View {
    private let channel: ChannelTree

    init(channel: ChannelTree) {
        self.channel = channel
    }

    // TODO: implement channelHeaderChannelName

    var body: some View {
        HStack {
            Text("#\(channel.name)")
                .font(.title)
                .bold()
            Text("|")
            Spacer()
            Button(action: {}, label: { Image(systemName: "phone") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "bell") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "star") }).foregroundColor(.black)
            Button(action: {}, label: { Image(systemName: "ellipsis") }).foregroundColor(.black)
        }
        .padding()
        .overlay(
            Rectangle().frame(height: 1).foregroundColor(.gray),
            alignment: .bottom
        )
        .navigationTitle("#h/o/g/e/\(channel.name)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChannelContentHeader_Previews: PreviewProvider {
    static var previews: some View {
        ChannelContentHeader(channel: .mockChannelTree.children![0])
    }
}
