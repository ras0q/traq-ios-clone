// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Stores",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Stores",
            targets: ["Stores"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.39.0"),
        .package(url: "https://github.com/Ras96/swift-traq.git", branch: "main"),
        .package(path: "../Models"),
    ],
    targets: [
        .target(
            name: "Stores",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Traq", package: "swift-traq"),
                "Models",
            ]
        ),
    ]
)
