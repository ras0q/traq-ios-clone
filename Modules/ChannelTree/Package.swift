// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "ChannelTree",
    products: [
        .library(
            name: "ChannelTree",
            targets: ["ChannelTree"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Ras96/swift-traq.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "ChannelTree",
            dependencies: [
                .product(name: "OpenAPIClient", package: "swift-traq"),
            ]
        ),
    ]
)
