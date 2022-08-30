import ComposableArchitecture
import Foundation
import Traq

public enum ServiceCore {
    public typealias Store = ComposableArchitecture.Store<ServiceCore.State, ServiceCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var channel: ChannelCore.State
        public var user: UserCore.State
        public var userMe: UserMeCore.State

        public init(
            channel: ChannelCore.State = .init(),
            user: UserCore.State = .init(),
            userMe: UserMeCore.State = .init()
        ) {
            self.channel = channel
            self.user = user
            self.userMe = userMe
        }
    }

    public enum Action: Equatable {
        case fetchAll

        case channel(ChannelCore.Action)
        case user(UserCore.Action)
        case userMe(UserMeCore.Action)

        public static func == (_: ServiceCore.Action, _: ServiceCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer = Reducer.combine(
        ChannelCore.reducer
            .pullback(
                state: \ServiceCore.State.channel,
                action: /ServiceCore.Action.channel,
                environment: { _ in ChannelCore.Environment() }
            ),
        UserCore.reducer
            .pullback(
                state: \ServiceCore.State.user,
                action: /ServiceCore.Action.user,
                environment: { _ in UserCore.Environment() }
            ),
        UserMeCore.reducer
            .pullback(
                state: \ServiceCore.State.userMe,
                action: /ServiceCore.Action.userMe,
                environment: { _ in UserMeCore.Environment() }
            ),
        Reducer { _, action, _ in
            switch action {
            case .fetchAll:
                return .run { send in
                    await send(.channel(.fetchChannels))
                    await send(.user(.fetchUsers))
                }
            default:
                return .none
            }
        }
    )
}

public extension ServiceCore.Store {
    static let defaultStore: ServiceCore.Store = .init(
        initialState: ServiceCore.State(),
        reducer: ServiceCore.reducer.debug(),
        environment: ServiceCore.Environment()
    )
}
