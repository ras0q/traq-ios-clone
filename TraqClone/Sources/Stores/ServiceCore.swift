import ComposableArchitecture
import Foundation
import Traq
import TraqWebsocket

public enum ServiceCore {
    public typealias Store = ComposableArchitecture.Store<ServiceCore.State, ServiceCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var channel: ChannelCore.State
        public var message: MessageCore.State
        public var user: UserCore.State
        public var userMe: UserMeCore.State

        public init(
            channel: ChannelCore.State = .init(),
            message: MessageCore.State = .init(),
            user: UserCore.State = .init(),
            userMe: UserMeCore.State = .init()
        ) {
            self.channel = channel
            self.message = message
            self.user = user
            self.userMe = userMe
        }
    }

    public enum Action: Equatable {
        case fetchAll
        case receiveWsEvent

        case channel(ChannelCore.Action)
        case message(MessageCore.Action)
        case user(UserCore.Action)
        case userMe(UserMeCore.Action)

        public static func == (_: ServiceCore.Action, _: ServiceCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public struct Environment {
        let websocket: WsClient

        public init(websocket: WsClient) {
            self.websocket = websocket
        }
    }

    public static let reducer = Reducer.combine(
        ChannelCore.reducer
            .pullback(
                state: \ServiceCore.State.channel,
                action: /ServiceCore.Action.channel,
                environment: { _ in ChannelCore.Environment() }
            ),
        MessageCore.reducer
            .pullback(
                state: \ServiceCore.State.message,
                action: /ServiceCore.Action.message,
                environment: { _ in MessageCore.Environment() }
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
        Reducer { _, action, environment in
            switch action {
            case .fetchAll:
                return .run { send in
                    await send(.channel(.fetchChannels))
                    await send(.user(.fetchUsers))
                    await send(.userMe(.fetchUnreadChannels))
                }
            case .receiveWsEvent:
                return .run { send in
                    let event = try await environment.websocket.receiveEvent()
                    await send(.receiveWsEvent)

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
                        await send(.channel(.fetchChannel(payload.id)))
                    case let .channelUpdated(payload):
                        await send(.channel(.fetchChannel(payload.id)))
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
                        await send(.message(.fetchMessage(payload.id, isCiting: payload.isCiting)))
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
                        await send(.userMe(.readChannel(payload.id)))
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
                } catch: { error, _ in
                    print(error)
                }
            case let .message(.fetchMessageResponse(.success((message, isCiting)))):
                return .run { send in
                    await send(.userMe(.addMessage(message, isCiting)))
                }
            case .channel, .message, .user, .userMe:
                return .none
            }
        }
    )
}

public extension ServiceCore.Store {
    static let defaultStore: ServiceCore.Store = AppCore
        .Store
        .defaultStore
        .scope(
            state: { _ in ServiceCore.State() },
            action: AppCore.Action.service
        )
}
