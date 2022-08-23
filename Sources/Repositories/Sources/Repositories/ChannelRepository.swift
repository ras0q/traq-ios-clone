import SwiftUI
import Traq

public protocol ChannelRepository {
    func fetchChannels(completion: @escaping ((_ data: TraqAPI.ChannelList) -> Void))
}

public final class ChannelRepositoryImpl: ChannelRepository {
    public var channels: [TraqAPI.Channel] = []

    public init() {}

    public func fetchChannels(completion: @escaping ((_ data: TraqAPI.ChannelList) -> Void)) {
        TraqAPI.ChannelAPI.getChannels(includeDm: false) { [self] response, error in
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
