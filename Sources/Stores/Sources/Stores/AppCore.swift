import ComposableArchitecture
import Foundation
import Models
import Traq

public enum AppCore {
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var auth: AuthCore.State = .init()
        public var channel: ChannelCore.State = .init()
        public var user: UserCore.State = .init()

        public init() {}
    }

    public enum Action {
        case auth(AuthCore.Action)
        case channel(ChannelCore.Action)
        case user(UserCore.Action)
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer: Reducer = Reducer.combine(
        AuthCore.reducer
            .pullback(
                state: \AppCore.State.auth,
                action: /AppCore.Action.auth,
                environment: { _ in AuthCore.Environment() }
            ),

        ChannelCore.reducer
            .pullback(
                state: \AppCore.State.channel,
                action: /AppCore.Action.channel,
                environment: { _ in ChannelCore.Environment() }
            ),
        UserCore.reducer
            .pullback(
                state: \AppCore.State.user,
                action: /AppCore.Action.user,
                environment: { _ in UserCore.Environment() }
            )
    )
}

public extension AppCore.Store {
    static let defaultAppStore: AppCore.Store = .init(
        initialState: AppCore.State(),
        reducer: AppCore.reducer.debug(),
        environment: AppCore.Environment()
    )
}
