import ComposableArchitecture
import Foundation
import Traq

public enum UserMeCore {
    public typealias Store = ComposableArchitecture.Store<UserMeCore.State, UserMeCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var userMe: TraqAPI.MyUserDetail?

        public init() {}
    }

    public enum Action: Equatable {
        case fetchMe
        case fetchMeResponse(TaskResult<TraqAPI.MyUserDetail>)

        public static func == (_: UserMeCore.Action, _: UserMeCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer = Reducer { state, action, _ in
        switch action {
        case .fetchMe:
            return .task {
                await .fetchMeResponse(
                    TaskResult {
                        try await TraqAPI.MeAPI.getMe()
                    }
                )
            }
        case let .fetchMeResponse(.success(userMe)):
            state.userMe = userMe
            return .none
        case let .fetchMeResponse(.failure(error)):
            print("failed to fetch your infomation: \(error)")
            return .none
        }
    }
}

public extension UserMeCore.Store {
    static let defaultStore: UserMeCore.Store = .init(
        initialState: UserMeCore.State(),
        reducer: UserMeCore.reducer.debug(),
        environment: UserMeCore.Environment()
    )
}
