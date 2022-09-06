import SDWebImageSwiftUI
import SwiftUI
import Traq

public struct UserElement: View {
    private let user: TraqAPI.User

    public init(user: TraqAPI.User) {
        self.user = user
    }

    public var body: some View {
        Button(action: {}) {
            HStack {
                WebImage(url: URL(string: "\(TraqAPI.basePath)/public/icon/\(user.name)"), isAnimating: .constant(true))
                    .onFailure { error in
                        print(error.localizedDescription)
                    }
                    .resizable()
                    .placeholder(Image(systemName: "person.crop.circle"))
                    .indicator(.activity) // Activity Indicator
                    .clipShape(Circle())
                    .frame(width: 35, height: 35, alignment: .leading)
                VStack(alignment: .leading) {
                    Text("\(user.displayName)")
                        .foregroundColor(.black)
                    Text("@\(user.name)")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
            }
        }
    }
}

struct UserElement_Previews: PreviewProvider {
    static var previews: some View {
        UserElement(user: .init(
            id: UUID(),
            name: "user1",
            displayName: "ユーザー1",
            iconFileId: UUID(),
            bot: false,
            state: .active,
            updatedAt: Date()
        ))
    }
}
