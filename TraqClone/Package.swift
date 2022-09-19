// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "TraqClone",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Stores", targets: ["Stores"]),
        .library(name: "Views", targets: ["Views"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.39.0"),
        .package(url: "https://github.com/Ras96/swift-traq", branch: "wip/apply-traq-migration-error"),
        .package(url: "https://github.com/Ras96/swift-traq-ws", branch: "main"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", from: "2.0.2"),
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
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
                .product(name: "Traq", package: "swift-traq"),
            ],
            exclude: [
                "Resources/web.bundle/node_modules",
            ],
            resources: [
                .process("Resources"),
            ]
        ),
    ]
)

// build tools
package.dependencies.append(contentsOf: [
    .package(url: "https://github.com/realm/SwiftLint", from: "0.48.0"),
    .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.17"),
])
