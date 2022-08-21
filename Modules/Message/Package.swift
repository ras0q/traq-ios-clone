// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Message",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Message",
            targets: ["Message"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Message",
            dependencies: []
        ),
    ]
)
