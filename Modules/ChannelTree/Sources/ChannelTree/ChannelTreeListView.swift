import OpenAPIClient
import SwiftUI

public struct ChannelTreeListView<Destination>: View where Destination: View {
    @ObservedObject var topChannels: ChannelNodes = .init(channels: [])
    private let destination: (ChannelNode) -> Destination
    @State private var openChannelContentView: Bool = false
    @State private var destChannel: ChannelNode?

    public init(destination: @escaping (ChannelNode) -> Destination) {
        #if DEBUG
            guard let token = ProcessInfo.processInfo.environment["TRAQ_ACCESS_TOKEN"] else {
                fatalError("token is empty")
            }

            OpenAPIClientAPI.customHeaders = ["Authorization": "Bearer \(token)"]
            OpenAPIClientAPI.basePath = "https://q-dev.trapti.tech/api/v3"
        #endif

        self.destination = destination

        ChannelAPI.getChannels(includeDm: false) { [self] response, error in
            guard error == nil else {
                print(error!)
                return
            }

            guard let response = response else {
                print("response is nil")
                return
            }

            guard let topChannels = ChannelNode(channels: response._public).children else {
                print("topChannels is nil")
                return
            }

            self.topChannels.channels = topChannels
        }
    }

    public var body: some View {
        ZStack {
            NavigationLink(
                isActive: $openChannelContentView,
                destination: { destination(destChannel ?? .mockTopChannels[0]) }
            ) {
                EmptyView()
            }
            .hidden()

            List(topChannels.channels, id: \.id, children: \.children) { channel in
                let imageView = Image(systemName: "number")
                    .fixedSize()
                    .padding(4)

                if (channel.children ?? []).isEmpty {
                    imageView
                } else {
                    imageView
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black, lineWidth: 2)
                        )
                }

                // use Text as a Button
                Text(channel.name)
                    .onTapGesture {
                        destChannel = channel
                        openChannelContentView = true
                    }
            }
        }
    }
}

struct ChannelTreeListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChannelTreeListView { _ in
                EmptyView()
            }
        }
        .navigationTitle("チャンネル")
    }
}
