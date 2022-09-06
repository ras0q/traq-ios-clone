import ComposableArchitecture
import Stores
import SwiftUI

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
                    UserElement(user: user)
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
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(store: ServiceCore.Store.defaultStore)
    }
}
