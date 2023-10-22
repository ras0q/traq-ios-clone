import Dependencies
import Foundation
import Traq

public struct ChannelAPI {
    public var getChannels: @Sendable (_ includeDM: Bool) async throws -> TraqAPI.ChannelList
}

extension ChannelAPI: DependencyKey {
    public static let liveValue = Self(
        getChannels: { includeDM in
            try await TraqAPI.ChannelAPI.getChannels(includeDm: includeDM)
        }
    )
}

extension ChannelAPI: TestDependencyKey {
    public static let previewValue = Self(
        getChannels: { _ in
            TraqAPI.ChannelList(_public: [], dm: [])
        }
    )

    public static let testValue = Self { _ in unimplemented() }
}

public extension DependencyValues {
    var channelAPI: ChannelAPI {
        get { self[ChannelAPI.self] }
        set { self[ChannelAPI.self] = newValue }
    }
}
