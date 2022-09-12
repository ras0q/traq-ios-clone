import ComposableArchitecture
import SDWebImageSwiftUI
import Stores
import SwiftUI
import Traq

public struct UserView: View {
    private let store: ServiceCore.Store

    public init(store: ServiceCore.Store) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List(getUsers(from: viewStore.user), id: \.id) { user in
                    userElementButton(user)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text("ユーザー")
                            .font(.largeTitle)
                            .bold()
                    }
                }
            }
        }
    }

    private func getUsers(from userState: UserCore.State) -> [TraqAPI.User] {
        userState.users
            .filter { !$0.bot && $0.state == .active }
            .sorted { $0.name.lowercased() < $1.name.lowercased() }
    }

    private func userElementButton(_ user: TraqAPI.User) -> some View {
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

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(store: .defaultStore)
    }
}
