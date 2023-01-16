import ComposableArchitecture
import Foundation
import Models
import Traq
import TraqWebsocket

public struct AppCore: ReducerProtocol {
    let websocket: WsClient

    public init(websocket: WsClient) {
        self.websocket = websocket
    }

    public enum State: Equatable {
        // 未ログイン時ステート。ログイン画面に遷移
        case auth(AuthCore.State)
        // ログイン後ステート。サービス画面に遷移
        case service(ServiceCore.State)

        public init(service: ServiceCore.State = .init()) {
            self = .service(service)
        }
    }

    public enum Action {
        case auth(AuthCore.Action)
        case service(ServiceCore.Action)
    }

    public var body: some ReducerProtocol<State, Action> {
        Reduce(core)
            .ifCaseLet(/State.auth, action: /Action.auth) { AuthCore() }
            .ifCaseLet(/State.service, action: /Action.service) { ServiceCore(websocket: websocket) }
    }

    private func core(state: inout State, action: Action) -> EffectTask<Action> {
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
}

public extension StoreOf<AppCore> {
    static let defaultStore: StoreOf<AppCore> = {
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

        return Store(
            initialState: appState,
            reducer: AppCore(websocket: wsClient)
        )
    }()
}
