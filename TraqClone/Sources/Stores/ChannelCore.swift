import ComposableArchitecture
import Foundation
import Traq

public enum ChannelCore {
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var channels: [TraqAPI.Channel] = .init()
        public var channelDictionary: [UUID: TraqAPI.Channel] { channels.toDictionary(id: \.id) }

        public init() {
            #if DEBUG
                channels = .mock
            #endif
        }
    }

    public enum Action: Equatable {
        case fetchChannels
        case fetchChannelsResponse(TaskResult<[TraqAPI.Channel]>)
        case fetchChannel(UUID)
        case fetchChannelResponse(TaskResult<TraqAPI.Channel>)

        public static func == (_: ChannelCore.Action, _: ChannelCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer = Reducer.combine(
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
            }
        }
    )
}
