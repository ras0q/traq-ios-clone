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
        .package(path: "../Components"),
        .package(path: "../Models"),
        .package(path: "../Repositories"),
    ],
    targets: [
        .target(
            name: "Views",
            dependencies: [
                "Components",
                "Models",
                "Repositories",
            ]
        ),
    ]
)
