import ComposableArchitecture
import Foundation
import Traq

public enum UserCore {
    public typealias Store = ComposableArchitecture.Store<UserCore.State, UserCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var users: [TraqAPI.User] = .init()
        public var userDictionary: [UUID: TraqAPI.User] {
            users.reduce([UUID: TraqAPI.User]()) { dic, user in
                var newDic = dic
                newDic[user.id] = user
                return newDic
            }
        }

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
