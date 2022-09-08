import ComposableArchitecture
import Foundation
import Traq

public enum MessageCore {
    public typealias Store = ComposableArchitecture.Store<MessageCore.State, MessageCore.Action>
    public typealias Reducer = ComposableArchitecture.Reducer<State, Action, Environment>

    public struct State: Equatable {
        public var messages: [TraqAPI.Message] = .init()
        public var messageDictionary: [UUID: TraqAPI.Message] { messages.toDictionary(id: \.id) }

        public init() {}
    }

    public enum Action: Equatable {
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
        case let .fetchMessage(messageId, isCiting: isCiting):
            return .task {
                await .fetchMessageResponse(
                    TaskResult {
                        let message = try await TraqAPI.MessageAPI.getMessage(messageId: messageId)
                        return (message: message, isCiting: isCiting)
                    }
                )
            }
        case let .fetchMessageResponse(.success((message, isCiting: _))):
            guard !state.messages.contains(where: { $0.id == message.id }) else {
                return .none
            }
            state.messages.append(message)
            return .none
        case let .fetchMessageResponse(.failure(error)):
            print("failed to fetch messages: \(error)")
            return .none
        }
    }
}
