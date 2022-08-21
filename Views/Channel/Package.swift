// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Channel",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Channel",
            targets: ["Channel"]
        ),
    ],
    dependencies: [
        .package(path: "../ChannelContent"),
        .package(path: "../../Modules/ChannelTree"),
    ],
    targets: [
        .target(
            name: "Channel",
            dependencies: [
                "ChannelContent",
                "ChannelTree",
            ]
        ),
    ]
)
