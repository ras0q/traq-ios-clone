import ComposableArchitecture
import Foundation
import Traq

public enum ChannelCore {
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var channels: [TraqAPI.Channel] = .init()
        public var channelDictionary: [UUID: TraqAPI.Channel] { channels.toDictionary(id: \.id) }

        public var user: UserCore.State

        public init(user: UserCore.State = .init()) {
            self.user = user
        }
    }

    public enum Action: Equatable {
        case fetchChannels
        case fetchChannelsResponse(TaskResult<[TraqAPI.Channel]>)
        case fetchChannel(UUID)
        case fetchChannelResponse(TaskResult<TraqAPI.Channel>)

        case user(UserCore.Action)

        public static func == (_: ChannelCore.Action, _: ChannelCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer = Reducer.combine(
        UserCore.reducer.pullback(
            state: \.user,
            action: /ChannelCore.Action.user,
            environment: { _ in UserCore.Environment() }
        ),
        Reducer { state, action, _ in
            switch action {
            case .fetchChannels:
                return .task {
                    await .fetchChannelsResponse(
                        TaskResult {
                            let channelList = try await TraqAPI.ChannelAPI.getChannels(includeDm: false)
                            return channelList._public
                        }
                    )
                }
            case let .fetchChannelsResponse(.success(channels)):
                state.channels = channels
                return .none
            case let .fetchChannelsResponse(.failure(error)):
                print("failed to fetch channels: \(error)")
                return .none
            case let .fetchChannel(channelId):
                return .task {
                    await .fetchChannelResponse(
                        TaskResult {
                            let channel = try await TraqAPI.ChannelAPI.getChannel(channelId: channelId)
                            return channel
                        }
                    )
                }
            case let .fetchChannelResponse(.success(channel)):
                var channels = state.channels
                channels.append(channel)
                state.channels = channels.sorted { $0.id.uuidString < $1.id.uuidString }
                return .none
            case let .fetchChannelResponse(.failure(error)):
                print("failed to fetch channel()")
                return .none
            case .user:
                return .none
            }
        }
    )
}

public extension ChannelCore.Store {
    static let defaultStore: ChannelCore.Store = .init(
        initialState: ChannelCore.State(),
        reducer: ChannelCore.reducer.debug(),
        environment: ChannelCore.Environment()
    )
}
