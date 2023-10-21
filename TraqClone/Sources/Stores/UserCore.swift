import ComposableArchitecture
import Foundation
import Traq

public struct UserCore: Reducer {
    public init() {}

    public struct State: Equatable {
        public var userDictionary: [UUID: TraqAPI.User] = [:]

        public init() {}
    }

    public enum Action: Equatable {
        case fetchUsers
        case response(TaskResult<[TraqAPI.User]>)

        public static func == (_: UserCore.Action, _: UserCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .fetchUsers:
            return .run { send in
                await send(.response(TaskResult {
                    try await TraqAPI.UserAPI.getUsers(includeSuspended: true)
                }))
            }
        case let .response(.success(users)):
            state.userDictionary = users.toDictionary(id: \.id)
            return .none
        case let .response(.failure(error)):
            print("failed to fetch users: \(error)")
            return .none
        }
    }
}
