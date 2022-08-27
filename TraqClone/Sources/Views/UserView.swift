import Components
import ComposableArchitecture
import Stores
import SwiftUI

public struct UserView: View {
    private let store: UserCore.Store

    public init(store: UserCore.Store) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store) { viewStore in
            NavigationView {
                List(
                    viewStore.users
                        .filter { !$0.bot && $0.state == .active }
                        .sorted { $0.name.lowercased() < $1.name.lowercased() },
                    id: \.id
                ) { user in
                    UserElementView(user: user)
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
        UserView(
            store: AppCore.Store.defaultAppStore
                .scope(
                    state: { $0.user },
                    action: AppCore.Action.user
                )
        )
    }
}
