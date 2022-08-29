import ComposableArchitecture
import Foundation
import Models
import Traq
import TraqWebsocket

public enum WsCore {
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {}

    public enum Action {
        case start
    }

    public struct Environment {
        let websocket: WsClient

        public init(websocket: WsClient) {
            self.websocket = websocket
        }
    }

    public static let reducer: Reducer = Reducer.combine(
        Reducer { _, action, environment in
            switch action {
            case .start:
                return .run { _ in
                    environment.websocket.onEvents { event in
                        switch event.body {
                        case let .userJoined(payload):
                            break
                        case let .userUpdated(payload):
                            break
                        case let .userTagsUpdated(payload):
                            break
                        case let .userIconUpdated(payload):
                            break
                        case let .userWebrtcStateChanged(payload):
                            break
                        case let .userViewstateChanged(payload):
                            break
                        case let .userOnline(payload):
                            break
                        case let .userOffline(payload):
                            break
                        case let .userGroupCreated(payload):
                            break
                        case let .userGroupUpdated(payload):
                            break
                        case let .userGroupDeleted(payload):
                            break
                        case let .channelCreated(payload):
                            break
                        case let .channelUpdated(payload):
                            break
                        case let .channelDeleted(payload):
                            break
                        case let .channelStared(payload):
                            break
                        case let .channelUnstared(payload):
                            break
                        case let .channelViewersChanged(payload):
                            break
                        case let .channelSubscribersChanged(payload):
                            break
                        case let .messageCreated(payload):
                            break
                        case let .messageUpdated(payload):
                            break
                        case let .messageDeleted(payload):
                            break
                        case let .messageStamped(payload):
                            break
                        case let .messageUnstamped(payload):
                            break
                        case let .messagePinned(payload):
                            break
                        case let .messageUnpinned(payload):
                            break
                        case let .messageRead(payload):
                            break
                        case let .stampCreated(payload):
                            break
                        case let .stampUpdated(payload):
                            break
                        case let .stampDeleted(payload):
                            break
                        case let .stampPaletteCreated(payload):
                            break
                        case let .stampPaletteUpdated(payload):
                            break
                        case let .stampPaletteDeleted(payload):
                            break
                        case let .clipFolderCreated(payload):
                            break
                        case let .clipFolderUpdated(payload):
                            break
                        case let .clipFolderDeleted(payload):
                            break
                        case let .clipFolderMessageAdded(payload):
                            break
                        case let .clipFolderMessageDeleted(payload):
                            break
                        }
                    }
                }
            }
        }
    )
}

public extension WsCore.Store {
    static let defaultStore: WsCore.Store = .init(
        initialState: WsCore.State(),
        reducer: WsCore.reducer.debug(),
        environment: WsCore.Environment(websocket: WsClient())
    )
}
