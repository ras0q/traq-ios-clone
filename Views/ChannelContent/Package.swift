// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "ChannelContent",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "ChannelContent",
            targets: ["ChannelContent"]
        ),
    ],
    dependencies: [
        .package(path: "../../Modules/ChannelTree"),
        .package(path: "../../Modules/Message"),
    ],
    targets: [
        .target(
            name: "ChannelContent",
            dependencies: [
                "ChannelTree",
                "Message",
            ]
        ),
    ]
)
