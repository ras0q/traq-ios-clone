import ComposableArchitecture
import Foundation
import Traq

public struct UserMeCore: ReducerProtocol {
    public struct State: Equatable {
        public var userMe: TraqAPI.MyUserDetail?
        public var unreadChannels: [TraqAPI.UnreadChannel] = .init()
        public var unreadChannelDictionary: [UUID: TraqAPI.UnreadChannel] { unreadChannels.toDictionary(id: \.channelId) }

        public init() {}
    }

    public enum Action: Equatable {
        case fetchMe
        case fetchMeResponse(TaskResult<TraqAPI.MyUserDetail>)
        case fetchUnreadChannels
        case fetchUnreadChannelsResponse(TaskResult<[TraqAPI.UnreadChannel]>)
        case addMessage(TraqAPI.Message, Bool)
        case readChannel(UUID)

        public static func == (_: UserMeCore.Action, _: UserMeCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchMe:
            return .task {
                await .fetchMeResponse(
                    TaskResult {
                        try await TraqAPI.MeAPI.getMe()
                    }
                )
            }
        case let .fetchMeResponse(.success(userMe)):
            state.userMe = userMe
            return .none
        case let .fetchMeResponse(.failure(error)):
            print("failed to fetch your infomation: \(error)")
            return .none
        case .fetchUnreadChannels:
            return .task {
                await .fetchUnreadChannelsResponse(
                    TaskResult {
                        try await TraqAPI.MeAPI.getMyUnreadChannels()
                    }
                )
            }
        case let .fetchUnreadChannelsResponse(.success(unreadChannels)):
            state.unreadChannels = unreadChannels
            return .none
        case let .fetchUnreadChannelsResponse(.failure(error)):
            print("failed to fetch unread channels: \(error)")
            return .none
        case let .addMessage(message, isCiting):
            // TODO: 閲覧中のチャンネルは未読に追加しない
            // 自分の投稿は未読に追加しない
            guard state.userMe?.id != message.userId else { return .none }
            let noticeable = isCiting // TODO: メンションされたときに通知を飛ばす
            // unreadChannelsのUpsert
            if let unreadChannel = state.unreadChannelDictionary[message.channelId] {
                let newUnreadChannel = TraqAPI.UnreadChannel(
                    channelId: unreadChannel.channelId,
                    count: unreadChannel.count + 1,
                    noticeable: unreadChannel.noticeable || noticeable,
                    since: unreadChannel.since,
                    updatedAt: message.createdAt
                )
                state.unreadChannels = state.unreadChannels.map {
                    $0.channelId == newUnreadChannel.channelId
                        ? newUnreadChannel
                        : $0
                }
            } else {
                state.unreadChannels.append(
                    TraqAPI.UnreadChannel(
                        channelId: message.channelId,
                        count: 1,
                        noticeable: noticeable,
                        since: message.createdAt,
                        updatedAt: message.createdAt
                    )
                )
            }
            return .none
        case let .readChannel(channelId):
            state.unreadChannels = state.unreadChannels.filter { $0.channelId != channelId }
            return .none
        }
    }
}
