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
    ],
    targets: [
        .target(
            name: "Components",
            dependencies: [
                "Models",
            ]
        ),
    ]
)
