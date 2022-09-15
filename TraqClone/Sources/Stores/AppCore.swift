import ComposableArchitecture
import Foundation
import Models
import Traq
import TraqWebsocket

public enum AppCore {
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public enum State: Equatable {
        // auth: 未ログイン時ステート。ログイン画面に遷移
        // service: ログイン後ステート。サービス画面に遷移
        case auth(AuthCore.State)
        case service(ServiceCore.State)

        public init(service: ServiceCore.State = .init()) {
            self = .service(service)
        }
    }

    public enum Action {
        case auth(AuthCore.Action)
        case service(ServiceCore.Action)
    }

    public struct Environment {
        let websocket: WsClient

        public init(websocket: WsClient) {
            self.websocket = websocket
        }
    }

    public static let reducer: Reducer = Reducer.combine(
        AuthCore.reducer
            .pullback(
                state: /AppCore.State.auth,
                action: /AppCore.Action.auth,
                environment: { _ in AuthCore.Environment() }
            ),
        ServiceCore.reducer
            .pullback(
                state: /AppCore.State.service,
                action: /AppCore.Action.service,
                environment: { ServiceCore.Environment(websocket: $0.websocket) }
            ),
        Reducer { state, action, _ in
            switch action {
            // ログインに成功したら自分のユーザー情報を取得する
            case .auth(.postLoginResponse(.success)):
                state = .service(.init())
                return .run { send in
                    await send(.service(.userMe(.fetchMe)))
                }
            // 自分のユーザー情報が取得できたら他の情報も取得する
            case .service(.userMe(.fetchMeResponse(.success))):
                return .run { send in
                    await send(.service(.fetchAll))
                }
            // 自分のユーザー情報の取得に失敗したらログイン画面に戻す
            case let .service(.userMe(.fetchMeResponse(.failure(error)))):
                state = .auth(.init())
                return .none
            case .auth, .service:
                return .none
            }
        }
    )
}

public extension AppCore.Store {
    static let defaultStore: AppCore.Store = {
        let channelState: ChannelCore.State = .init()
        let userState: UserCore.State = .init()
        let userMeState: UserMeCore.State = .init()
        let serviceState: ServiceCore.State = .init(
            channel: channelState,
            user: userState,
            userMe: userMeState
        )
        let appState: AppCore.State = .init(service: serviceState)

        let wsClient: WsClient = .init()
        wsClient.resume()

        return AppCore.Store(
            initialState: appState,
            reducer: AppCore.reducer.debug(),
            environment: AppCore.Environment(websocket: wsClient)
        )
    }()
}
