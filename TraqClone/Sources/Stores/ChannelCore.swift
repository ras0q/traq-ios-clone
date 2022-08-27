import ComposableArchitecture
import Foundation
import Traq

public enum ChannelCore {
    public typealias Store = ComposableArchitecture.Store<State, Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var channels: [TraqAPI.Channel] = .init()
        public var channelDictionary: [UUID: TraqAPI.Channel] {
            channels.reduce([UUID: TraqAPI.Channel]()) { dic, channel in
                var newDic = dic
                newDic[channel.id] = channel
                return newDic
            }
        }

        public var user: UserCore.State = .init()

        public init() {}
    }

    public enum Action: Equatable {
        case fetchChannels
        case response(TaskResult<[TraqAPI.Channel]>)
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
                    await .response(
                        TaskResult {
                            let channelList = try await TraqAPI.ChannelAPI.getChannels(includeDm: false)
                            return channelList._public
                        }
                    )
                }
            case let .response(.success(channels)):
                state.channels = channels
                return .none
            case let .response(.failure(error)):
                print("failed to fetch channels: \(error)")
                return .none
            case .user:
                return .none
            }
        }
    )
}
