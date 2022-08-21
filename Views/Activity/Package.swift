// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Activity",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Activity",
            targets: ["Activity"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Activity",
            dependencies: []
        ),
    ]
)
