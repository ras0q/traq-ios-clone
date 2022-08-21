// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Home",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Home",
            targets: ["Home"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Home",
            dependencies: []
        ),
    ]
)
