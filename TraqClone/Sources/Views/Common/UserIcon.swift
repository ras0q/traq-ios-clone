import SwiftUI
import Traq

public struct UserIcon: View {
    private static var iconImageDictionary: [URL?: Image] = [:]

    private let iconUrl: URL?

    public init(iconFileId: UUID) {
        iconUrl = URL(string: "\(TraqAPI.basePath)/files/\(iconFileId.uuidString)")
    }

    public var body: some View {
        if let image = UserIcon.iconImageDictionary[iconUrl] {
            image
                .resizable()
                .clipShape(Circle())
        } else {
            AsyncImage(url: iconUrl) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .clipShape(Circle())
                        .task(id: iconUrl) {
                            UserIcon.iconImageDictionary[iconUrl] = image
                        }
                case .empty:
                    ProgressView()
                        .clipShape(Circle())
                case .failure:
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .clipShape(Circle())
                @unknown default:
                    fatalError("unknown phase")
                }
            }
        }
    }
}
