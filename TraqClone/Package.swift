// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "TraqClone",
    platforms: [
        .iOS(.v16),
        .macOS(.v12),
    ],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Stores", targets: ["Stores"]),
        .library(name: "Views", targets: ["Views"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.49.2"),
        .package(url: "https://github.com/traPtitech/swift-traq", branch: "main"),
        .package(url: "https://github.com/ras0q/swift-traq-ws", branch: "main"),
    ],
    targets: [
        // Views->Stores->Modelsの方向にのみ依存するようにする
        .target(
            name: "Models",
            dependencies: [
                .product(name: "Traq", package: "swift-traq"),
            ]
        ),
        .target(
            name: "Stores",
            dependencies: [
                "Models",
                .product(name: "TraqWebsocket", package: "swift-traq-ws"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Traq", package: "swift-traq"),
            ]
        ),
        .target(
            name: "Views",
            dependencies: [
                "Stores",
                "Models",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Traq", package: "swift-traq"),
            ]
        ),
    ]
)

// build tools
package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.48.0"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.17"),
])
