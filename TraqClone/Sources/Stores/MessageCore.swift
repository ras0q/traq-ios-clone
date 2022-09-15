import ComposableArchitecture
import Foundation
import Traq

public enum MessageCore {
    public typealias Store = ComposableArchitecture.Store<MessageCore.State, MessageCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var channelMesssages: [UUID: [TraqAPI.Message]] = .init()

        public init() {}
    }

    public enum Action: Equatable {
        case fetchMessages(channelId: UUID)
        case fetchMessagesResponse(TaskResult<([TraqAPI.Message], channelId: UUID)>)
        case fetchMessage(UUID, isCiting: Bool)
        case fetchMessageResponse(TaskResult<(TraqAPI.Message, isCiting: Bool)>)

        public static func == (_: MessageCore.Action, _: MessageCore.Action) -> Bool {
            fatalError("not implemented")
        }
    }

    public struct Environment {
        public init() {}
    }

    public static let reducer = Reducer { state, action, _ in
        switch action {
        case let .fetchMessages(channelId: channelId):
            return .task {
                await .fetchMessagesResponse(
                    TaskResult {
                        let messages = try await TraqAPI.MessageAPI.getMessages(channelId: channelId)
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
            return .none
        case let .fetchMessagesResponse(.failure(error)):
            print("failed to fetch messages: \(error)")
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
