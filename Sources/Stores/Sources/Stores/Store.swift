import ComposableArchitecture
import Models
import SwiftUI
import Traq

public typealias AppStore = Store<AppState, AppAction>

public extension AppStore {
    static let defaultAppStore: AppStore = .init(
        initialState: AppState(),
        reducer: appReducer.debug(),
        environment: AppEnvironment()
    )

    func initializeData() {
        // TODO: ログインしてなかったらLoginViewに遷移させる
        let viewStore = ViewStore(scope(state: ViewState.init(state:)))
        viewStore.send(.fetchChannels)
        viewStore.send(.fetchUsers)
    }
}

public struct AppState: Equatable {
    public var userMe: TraqAPI.MyUserDetail?
    public var users: [TraqAPI.User] = []
    public var channels: [TraqAPI.Channel] = []

    public init() {}

    // computed properties
    public var channelDictionary: [UUID: TraqAPI.Channel] {
        arr2dict(channels, id: \.id)
    }

    public var userDictionary: [UUID: TraqAPI.User] {
        arr2dict(users, id: \.id)
    }

    private func arr2dict<K, V>(_ array: [V], id: KeyPath<V, K>) -> [K: V] {
        array.reduce([K: V]()) { dic, value in
            var newDic = dic
            newDic[value[keyPath: id]] = value
            return newDic
        }
    }
}

public struct ViewState: Equatable {
    public init(state _: AppState) {}
}

public enum AppAction {
    case postLogin(String, String)
    case postLoginResponse(TaskResult<Void>)
    case postLogout
    case postLogoutResponse(TaskResult<Void>)
    case fetchAll
    case resetAll
    case fetchMe
    case fetchChannels
    case fetchUsers
    case fetchResponse(TaskResult<Any>)
}

public struct AppEnvironment {
    public var mainQueue: DispatchQueue = .global()

    public init() {}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, _ in
    switch action {
    case let .postLogin(traqId, password):
        return .task {
            await .postLoginResponse(
                TaskResult {
                    try await TraqAPI.AuthenticationAPI.login(
                        postLoginRequest: .init(name: traqId, password: password)
                    )
                }
            )
        }
    case .postLoginResponse(.success):
        return .run { send in
            await send(.fetchAll)
        }
    case let .postLoginResponse(.failure(error)):
        return .run { send in
            await send(.fetchResponse(.failure(error)))
        }
    case .postLogout:
        return .task {
            await .postLogoutResponse(
                TaskResult {
                    try await TraqAPI.AuthenticationAPI.logout()
                }
            )
        }
    case .postLogoutResponse(.success):
        return .run { send in
            await send(.resetAll)
        }
    case let .postLogoutResponse(.failure(error)):
        return .run { send in
            await send(.fetchResponse(.failure(error)))
        }
    case .fetchMe:
        return .task {
            await .fetchResponse(
                TaskResult {
                    try await TraqAPI.MeAPI.getMe()
                }
            )
        }
    case .fetchChannels:
        return .task {
            await .fetchResponse(
                TaskResult {
                    try await TraqAPI.ChannelAPI.getChannels(includeDm: false)
                }
            )
        }
    case .fetchUsers:
        return .task {
            await .fetchResponse(
                TaskResult {
                    try await TraqAPI.UserAPI.getUsers(includeSuspended: true)
                }
            )
        }
    case .fetchAll:
        return .run { send in
            await send(.fetchMe)
            await send(.fetchChannels)
            await send(.fetchUsers)
        }
    case .resetAll:
        state.userMe = nil
        state.channels = []
        state.users = []
        return .none
    case let .fetchResponse(.success(response)):
        switch response {
        case let response as TraqAPI.MyUserDetail:
            state.userMe = response
        case let response as TraqAPI.ChannelList:
            state.channels = response._public
        case let response as [TraqAPI.User]:
            state.users = response
        default:
            fatalError("unknown response type")
        }
        return .none
    case let .fetchResponse(.failure(error)):
        print(error)
        return .none
    }
}
