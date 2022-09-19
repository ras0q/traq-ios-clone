import ComposableArchitecture
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
                List(
                    viewStore.user.users
                        .filter { !$0.bot && $0.state == .active }
                        .sorted { $0.name.lowercased() < $1.name.lowercased() },
                    id: \.id
                ) { user in
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

    private func userElementButton(_ user: TraqAPI.User) -> some View {
        Button(action: {}) {
            HStack {
                UserIcon(userName: user.name)
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