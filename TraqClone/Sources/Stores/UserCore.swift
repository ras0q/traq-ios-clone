import ComposableArchitecture
import Foundation
import Traq

public struct UserCore: ReducerProtocol {
    public init() {}

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

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
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
