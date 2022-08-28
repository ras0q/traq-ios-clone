import ComposableArchitecture
import Foundation
import Models
import Traq

public enum AuthCore {
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public enum State: Equatable {
        case login

        public init() {
            self = .login
        }
    }

    public enum Action {
        case postLogin(name: String, password: String)
        case postLoginResponse(TaskResult<Void>)
        case postLogout
        case postLogoutResponse(TaskResult<Void>)
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer: Reducer = Reducer.combine(
        Reducer { _, action, _ in
            switch action {
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
    )
}

public extension AuthCore.Store {
    static let defaultStore: AuthCore.Store = .init(
        initialState: AuthCore.State(),
        reducer: AuthCore.reducer.debug(),
        environment: AuthCore.Environment()
    )
}
