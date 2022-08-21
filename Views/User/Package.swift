// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "User",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "User",
            targets: ["User"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "User",
            dependencies: []
        ),
    ]
)
