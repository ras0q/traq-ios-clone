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
    dependencies: [
        .package(url: "https://github.com/Ras96/swift-traq.git", branch: "main"), // TODO: remove this dependency
    ],
    targets: [
        .target(
            name: "Models",
            dependencies: [
                .product(name: "Traq", package: "swift-traq"),
            ]
        ),
    ]
)
