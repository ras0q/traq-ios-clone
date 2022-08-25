// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Views",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Views",
            targets: ["Views"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.39.0"),
        .package(path: "../Components"),
        .package(path: "../Models"),
        .package(path: "../Stores"),
    ],
    targets: [
        .target(
            name: "Views",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "Components",
                "Models",
                "Stores",
            ]
        ),
    ]
)
