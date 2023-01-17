import ComposableArchitecture
import Foundation
import Traq

public struct ChannelCore: ReducerProtocol {
    public struct State: Equatable {
        public var channelDictionary: [UUID: TraqAPI.Channel] = [:]

        public init() {}
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

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
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
            state.channelDictionary = channels.toDictionary(id: \.id)
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
            var channelDictionary = state.channelDictionary
            channelDictionary[channel.id] = channel
            state.channelDictionary = channelDictionary
            return .none
        case let .fetchChannelResponse(.failure(error)):
            print("failed to fetch channel(): \(error)")
            return .none
        }
    }
}
