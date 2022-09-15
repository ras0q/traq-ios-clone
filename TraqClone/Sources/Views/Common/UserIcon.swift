import SDWebImageSwiftUI
import SwiftUI
import Traq

public struct UserIcon: View {
    private let iconUrl: URL?

    // FIXME: cannot load image
    public init(iconFileId: UUID) {
        iconUrl = URL(string: "\(TraqAPI.basePath)/files/\(iconFileId.uuidString)")
    }

    public init(userName: String) {
        iconUrl = URL(string: "\(TraqAPI.basePath)/public/icon/\(userName)")
    }

    public var body: some View {
        WebImage(url: iconUrl, isAnimating: .constant(true))
            .onFailure { error in
                print(error.localizedDescription)
            }
            .resizable()
            .placeholder(Image(systemName: "person.crop.circle"))
            .indicator(.activity)
            .clipShape(Circle())
    }
}
