import ComposableArchitecture
import Foundation
import Traq

public enum AuthCore {
    public typealias Store = ComposableArchitecture.Store<AuthCore.State, AuthCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var userMe: TraqAPI.MyUserDetail?
        public var isLogined: Bool {
            userMe != nil
        }

        public init() {}
    }

    public enum Action: Equatable {
        case fetchMe
        case fetchMeResponse(TaskResult<TraqAPI.MyUserDetail>)
        case postLogin(name: String, password: String)
        case postLoginResponse(TaskResult<Void>)
        case postLogout
        case postLogoutResponse(TaskResult<Void>)

        public static func == (_: AuthCore.Action, _: AuthCore.Action) -> Bool {
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
        case let .postLogin(name: name, password: password):
            return .task {
                await .postLoginResponse(
                    TaskResult {
                        try await TraqAPI.AuthenticationAPI.login(
                            postLoginRequest: TraqAPI.PostLoginRequest(
                                name: name,
                                password: password
                            )
                        )
                    }
                )
            }
        case .postLoginResponse(.success):
            return .none
        case let .postLoginResponse(.failure(error)):
            print("failed to login: \(error)")
            return .none
        case .postLogout:
            return .task {
                await .postLogoutResponse(
                    TaskResult {
                        try await TraqAPI.AuthenticationAPI.logout()
                    }
                )
            }
        case .postLogoutResponse(.success):
            return .none
        case let .postLogoutResponse(.failure(error)):
            print("failed to logout: \(error)")
            return .none
        }
    }
}
