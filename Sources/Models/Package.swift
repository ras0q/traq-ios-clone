// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Models",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Models",
            targets: ["Models"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Models",
            dependencies: []
        ),
    ]
)
