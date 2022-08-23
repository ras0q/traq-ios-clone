// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Components",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Components",
            targets: ["Components"]
        ),
    ],
    dependencies: [
        .package(path: "../Models"),
        .package(url: "https://github.com/Ras96/swift-traq.git", branch: "main"), // TODO: remove this dependency
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                "Models",
                .product(name: "Traq", package: "swift-traq"),
            ]
        ),
    ]
)
