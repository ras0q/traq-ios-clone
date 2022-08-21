// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Clip",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Clip",
            targets: ["Clip"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Clip",
            dependencies: []
        ),
    ]
)
