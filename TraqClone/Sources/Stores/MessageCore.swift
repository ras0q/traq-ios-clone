import ComposableArchitecture
import Foundation
import Traq

public struct MessageCore: ReducerProtocol {
    public struct State: Equatable {
        public var channelMesssages: [UUID: [TraqAPI.Message]] = .init()
        public var recentMessages: [TraqAPI.Message] {
            [TraqAPI.Message](
                channelMesssages
                    .values
                    .reduce([TraqAPI.Message]()) { result, messages in
                        var newResult = result
                        newResult.append(contentsOf: messages)
                        return newResult
                    }
                    .sorted { $0.createdAt > $1.createdAt }
                    .prefix(20)
            )
        }

        public var isFetchingMessages: Bool = false

        public init() {}
    }

    public enum Action: Equatable {
        case fetchMessages(
            channelId: UUID,
            limit: Int? = nil,
            offset: Int? = nil,
            since: Date? = nil,
            until: Date? = nil,
            inclusive: Bool? = nil
        )
        case fetchMessagesResponse(TaskResult<([TraqAPI.Message], channelId: UUID)>)
        case fetchMessage(UUID, isCiting: Bool)
        case fetchMessageResponse(TaskResult<(TraqAPI.Message, isCiting: Bool)>)

        public static func == (_: MessageCore.Action, _: MessageCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case let .fetchMessages(
            channelId: channelId,
            limit: limit,
            offset: offset,
            since: since,
            until: until,
            inclusive: inclusive
        ):
            state.isFetchingMessages = true
            return .task {
                return await .fetchMessagesResponse(
                    TaskResult {
                        let messages = try await TraqAPI.MessageAPI.getMessages(
                            channelId: channelId,
                            limit: limit,
                            offset: offset,
                            since: since,
                            until: until,
                            inclusive: inclusive
                        )
                        return (messages, channelId: channelId)
                    }
                )
            }
        case let .fetchMessagesResponse(.success((messages, channelId: channelId))):
            if var channelMessages = state.channelMesssages[channelId] {
                channelMessages = channelMessages.filter { !messages.map(\.id).contains($0.id) }
                channelMessages.append(contentsOf: messages)
                state.channelMesssages[channelId] = channelMessages
            } else {
                state.channelMesssages[channelId] = messages
            }
            state.isFetchingMessages = false
            return .none
        case let .fetchMessagesResponse(.failure(error)):
            print("failed to fetch messages: \(error)")
            state.isFetchingMessages = false
            return .none
        case let .fetchMessage(messageId, isCiting: isCiting):
            return .task {
                await .fetchMessageResponse(
                    TaskResult {
                        let message = try await TraqAPI.MessageAPI.getMessage(messageId: messageId)
                        return (message, isCiting: isCiting)
                    }
                )
            }
        case let .fetchMessageResponse(.success((message, isCiting: _))):
            let channelId = message.channelId
            if let channelMessages = state.channelMesssages[channelId] {
                guard !channelMessages.contains(where: { $0.id == message.id }) else {
                    return .none
                }
                state.channelMesssages[channelId]!.append(message)
            } else {
                state.channelMesssages[channelId] = [message]
            }
            return .none
        case let .fetchMessageResponse(.failure(error)):
            print("failed to fetch messages: \(error)")
            return .none
        }
    }
}
