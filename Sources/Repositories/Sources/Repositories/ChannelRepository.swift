import OpenAPIClient
import SwiftUI

public protocol ChannelRepository {
    func fetchChannels(completion: @escaping ((_ data: ChannelList) -> Void))
}

public final class ChannelRepositoryImpl: ChannelRepository {
    public var channels: [Channel] = []

    public init() {}

    public func fetchChannels(completion: @escaping ((_ data: ChannelList) -> Void)) {
        ChannelAPI.getChannels(includeDm: false) { [self] response, error in
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
}
