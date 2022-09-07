import ComposableArchitecture
import Foundation
import Traq

public enum UserMeCore {
    public typealias Store = ComposableArchitecture.Store<UserMeCore.State, UserMeCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var userMe: TraqAPI.MyUserDetail?
        public var unreadChannels: [TraqAPI.UnreadChannel] = .init()

        public init() {}
    }

    public enum Action: Equatable {
        case fetchMe
        case fetchMeResponse(TaskResult<TraqAPI.MyUserDetail>)
        case fetchUnreadChannels
        case fetchUnreadChannelsResponse(TaskResult<[TraqAPI.UnreadChannel]>)
        case readChannel(UUID)

        public static func == (_: UserMeCore.Action, _: UserMeCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer = Reducer { state, action, _ in
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
        case let .readChannel(channelId):
            state.unreadChannels = state.unreadChannels.filter { $0.channelId != channelId }
            return .none
        }
    }
}
