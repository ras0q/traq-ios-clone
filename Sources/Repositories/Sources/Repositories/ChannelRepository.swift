import SwiftUI
import Traq

public protocol ChannelRepository {
    func fetchChannels(completion: @escaping ((_ data: TraqAPI.ChannelList) -> Void))
    func fetchChannelMessages(channelId: UUID, options: FetchChannelMessagesOptions?, completion: @escaping ((_ data: [TraqAPI.Message]) -> Void))
}

public struct FetchChannelMessagesOptions {
    let limit: Int?
    let offset: Int?
    let since: Date?
    let until: Date?
    let inclusive: Bool?
    let order: TraqAPI.ChannelAPI.Order_getMessages?

    public init(
        limit: Int? = nil,
        offset: Int? = nil,
        since: Date? = nil,
        until: Date? = nil,
        inclusive: Bool? = nil,
        order: TraqAPI.ChannelAPI.Order_getMessages? = nil
    ) {
        self.limit = limit
        self.offset = offset
        self.since = since
        self.until = until
        self.inclusive = inclusive
        self.order = order
    }
}

public final class ChannelRepositoryImpl: ChannelRepository {
    public var channels: [TraqAPI.Channel] = []
    public var channelMessages: [UUID: [TraqAPI.Message]] = [:]
    private typealias API = TraqAPI.ChannelAPI

    public init() {}

    public func fetchChannels(completion: @escaping ((_ data: TraqAPI.ChannelList) -> Void)) {
        API.getChannels(includeDm: false) { [self] response, error in
            guard error == nil else {
                print(error!)
                return
            }

            guard let response = response else {
                print("response is nil")
                return
            }

            channels = response._public

            completion(response)
        }
    }

    public func fetchChannelMessages(channelId: UUID, options: FetchChannelMessagesOptions?, completion: @escaping ((_ data: [TraqAPI.Message]) -> Void)) {
        API.getMessages(
            channelId: channelId,
            limit: options?.limit,
            offset: options?.offset,
            since: options?.since,
            until: options?.until,
            inclusive: options?.inclusive,
            order: options?.order
        ) { [self] response, error in
            guard error == nil else {
                print(error!)
                return
            }

            guard let response = response else {
                print("response is nil")
                return
            }

            channelMessages[channelId] = response

            completion(response)
        }
    }
}
