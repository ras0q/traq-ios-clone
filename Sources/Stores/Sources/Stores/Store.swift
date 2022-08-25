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
        let viewStore = ViewStore(scope(state: ViewState.init(state:)))
        viewStore.send(.fetchChannels)
        viewStore.send(.fetchUsers)
    }
}

public struct AppState: Equatable {
    public var editMode: EditMode = .inactive
    public var channels: [TraqAPI.Channel] = .init()
    public var users: [TraqAPI.User] = .init()

    public init() {}
}

public struct ViewState: Equatable {
    public let editMode: EditMode

    public init(state: AppState) {
        editMode = state.editMode
    }
}

public enum AppAction: Equatable {
    public static func == (_: AppAction, _: AppAction) -> Bool {
        true
    }

    case fetchChannels
    case fetchUsers
    case fetchResponse(TaskResult<Any>)
}

public struct AppEnvironment {
    public var mainQueue: DispatchQueue = .global()

    public init() {}
}

public let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    @Sendable func execute<T>(_ requestBuilder: RequestBuilder<T>, _ queue: DispatchQueue = environment.mainQueue) throws -> T {
        // NOTE: 生成されるコードがメソッド内で非同期処理を行うためDispatchGroupを使って処理の流れを制御している
        let group = DispatchGroup()
        group.enter()

        var result: Result<Response<T>, ErrorResponse> = .failure(.error(500, nil, nil, DownloadException.responseFailed))
        requestBuilder.execute(queue) { apiResult in
            result = apiResult
            group.leave()
        }

        group.wait()

        switch result {
        case let .success(response):
            return response.body
        case let .failure(error):
            throw error
        }
    }

    switch action {
    case .fetchChannels:
        return .task {
            await .fetchResponse(
                TaskResult {
                    try execute(TraqAPI.ChannelAPI.getChannelsWithRequestBuilder(includeDm: false))
                }
            )
        }
    case .fetchUsers:
        return .task {
            await .fetchResponse(
                TaskResult {
                    try execute(TraqAPI.UserAPI.getUsersWithRequestBuilder(includeSuspended: true))
                }
            )
        }
    case let .fetchResponse(.success(response)):
        switch response {
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
