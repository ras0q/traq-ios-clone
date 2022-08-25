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
        .package(url: "https://github.com/Ras96/swift-traq.git", branch: "main"),
        .package(path: "../Components"),
    ],
    targets: [
        .target(
            name: "Stores",
            dependencies: [
                .product(name: "Traq", package: "swift-traq"),
                "Components",
            ]
        ),
    ]
)
