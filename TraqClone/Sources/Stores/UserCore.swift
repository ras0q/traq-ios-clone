import ComposableArchitecture
import Foundation
import Traq

public enum UserCore {
    public typealias Store = ComposableArchitecture.Store<UserCore.State, UserCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var users: [TraqAPI.User] = .init()
        public var userDictionary: [UUID: TraqAPI.User] { users.toDictionary(id: \.id) }

        public init() {}
    }

    public enum Action: Equatable {
        case fetchUsers
        case response(TaskResult<[TraqAPI.User]>)

        public static func == (_: UserCore.Action, _: UserCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer = Reducer { state, action, _ in
        switch action {
        case .fetchUsers:
            return .task {
                await .response(
                    TaskResult {
                        try await TraqAPI.UserAPI.getUsers(includeSuspended: true)
                    }
                )
            }
        case let .response(.success(users)):
            state.users = users
            return .none
        case let .response(.failure(error)):
            print("failed to fetch users: \(error)")
            return .none
        }
    }
}

public extension UserCore.Store {
    static let defaultStore: UserCore.Store = .init(
        initialState: UserCore.State(),
        reducer: UserCore.reducer.debug(),
        environment: UserCore.Environment()
    )
}
