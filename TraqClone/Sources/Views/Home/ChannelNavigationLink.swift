import SwiftUI

struct ChannelNavigationLink<Destination>: View where Destination: View {
    private let channelPath: String
    private let count: Int?
    private let destination: () -> Destination

    public init(
        channelPath: String,
        count: Int? = nil,
        destination: @escaping () -> Destination
    ) {
        self.channelPath = channelPath
        self.count = count
        self.destination = destination
    }

    var body: some View {
        NavigationLink(
            destination: destination(),
            label: {
                HStack {
                    Text(channelPath)
                    Spacer()
                    if let count = count {
                        Text("\(count)")
                            .foregroundColor(.gray)
                    }
                }
            }
        )
    }
}

struct ChannelNavigationLink_Previews: PreviewProvider {
    static var previews: some View {
        ChannelNavigationLink(
            channelPath: "preview/to/children",
            count: 10
        ) {
            EmptyView()
        }
    }
}
