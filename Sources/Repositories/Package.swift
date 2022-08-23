// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Repositories",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Repositories",
            targets: ["Repositories"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Ras96/swift-traq.git", branch: "main"),
    ],
    targets: [
        .target(
            name: "Repositories",
            dependencies: [
                .product(name: "OpenAPIClient", package: "swift-traq"),
            ]
        ),
    ]
)
