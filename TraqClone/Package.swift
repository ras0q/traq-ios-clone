// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "TraqClone",
    platforms: [
        .iOS(.v14),
        .macOS(.v12),
    ],
    products: [
        .library(name: "Components", targets: ["Components"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Stores", targets: ["Stores"]),
        .library(name: "Views", targets: ["Views"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.39.0"),
        .package(url: "https://github.com/Ras96/swift-traq.git", branch: "wip/apply-traq-migration-error"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI", from: "2.0.2"),
    ],
    targets: [
        // Views->Components->Stores->Modelsの方向にのみ依存するようにする
        .target(
            name: "Components",
            dependencies: [
                "Models",
                .product(name: "Traq", package: "swift-traq"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI"),
            ]
        ),
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
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Traq", package: "swift-traq"),
            ]
        ),
        .target(
            name: "Views",
            dependencies: [
                "Components",
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
