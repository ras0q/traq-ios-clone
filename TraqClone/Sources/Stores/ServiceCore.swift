import ComposableArchitecture
import Foundation
import Traq
import TraqWebsocket

public struct ServiceCore: ReducerProtocol {
    let websocket: WsClient

    public init(websocket: WsClient) {
        self.websocket = websocket
    }

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

    public var body: some ReducerProtocol<State, Action> {
        Scope(state: \.channel, action: /Action.channel) { ChannelCore() }
        Scope(state: \.message, action: /Action.message) { MessageCore() }
        Scope(state: \.user, action: /Action.user) { UserCore() }
        Scope(state: \.userMe, action: /Action.userMe) { UserMeCore() }
        Reduce(self.core)
    }

    private func core(state _: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchAll:
            return .run { send in
                await send(.channel(.fetchChannels))
                await send(.user(.fetchUsers))
                await send(.userMe(.fetchUnreadChannels))
            }
        case .receiveWsEvent:
            return .run { send in
                let event = try await websocket.receiveEvent()
                await send(.receiveWsEvent)
                await handleWsEvent(send, event)
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

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    private func handleWsEvent(_ send: Send<ServiceCore.Action>, _ event: WsEvent) async {
        switch event.body {
        case .userJoined:
            break
        case .userUpdated:
            break
        case .userTagsUpdated:
            break
        case .userIconUpdated:
            break
        case .userWebrtcStateChanged:
            break
        case .userViewstateChanged:
            break
        case .userOnline:
            break
        case .userOffline:
            break
        case .userGroupCreated:
            break
        case .userGroupUpdated:
            break
        case .userGroupDeleted:
            break
        case let .channelCreated(payload):
            await send(.channel(.fetchChannel(payload.id)))
        case let .channelUpdated(payload):
            await send(.channel(.fetchChannel(payload.id)))
        case .channelDeleted:
            break
        case .channelStared:
            break
        case .channelUnstared:
            break
        case .channelViewersChanged:
            break
        case .channelSubscribersChanged:
            break
        case let .messageCreated(payload):
            await send(.message(.fetchMessage(payload.id, isCiting: payload.isCiting)))
        case .messageUpdated:
            break
        case .messageDeleted:
            break
        case .messageStamped:
            break
        case .messageUnstamped:
            break
        case .messagePinned:
            break
        case .messageUnpinned:
            break
        case let .messageRead(payload):
            await send(.userMe(.readChannel(payload.id)))
        case .stampCreated:
            break
        case .stampUpdated:
            break
        case .stampDeleted:
            break
        case .stampPaletteCreated:
            break
        case .stampPaletteUpdated:
            break
        case .stampPaletteDeleted:
            break
        case .clipFolderCreated:
            break
        case .clipFolderUpdated:
            break
        case .clipFolderDeleted:
            break
        case .clipFolderMessageAdded:
            break
        case .clipFolderMessageDeleted:
            break
        }
    }
}

public extension StoreOf<ServiceCore> {
    static let defaultStore: StoreOf<ServiceCore> = StoreOf<AppCore>
        .defaultStore
        .scope(
            state: { _ in ServiceCore.State() },
            action: AppCore.Action.service
        )
}
