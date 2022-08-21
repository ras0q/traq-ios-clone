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
    dependencies: [],
    targets: [
        .target(
            name: "ChannelContent",
            dependencies: []
        ),
    ]
)
