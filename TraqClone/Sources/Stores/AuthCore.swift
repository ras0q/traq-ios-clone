import ComposableArchitecture
import Foundation
import Models
import Traq

public struct AuthCore: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case postLogin(name: String, password: String)
        case postLoginResponse(TaskResult<Void>)
        case postLogout
        case postLogoutResponse(TaskResult<Void>)
    }

    public func reduce(into _: inout State, action: Action) -> EffectTask<Action> {
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
}

public extension StoreOf<AuthCore> {
    static let defaultStore: StoreOf<AuthCore> = StoreOf<AppCore>
        .defaultStore
        .scope(
            state: { _ in AuthCore.State() },
            action: AppCore.Action.auth
        )
}
