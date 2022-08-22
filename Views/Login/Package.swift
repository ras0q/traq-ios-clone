// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Login",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Login",
            targets: ["Login"]
        ),
    ],
    dependencies: [
        .package(path: "../../Modules/Repositories"),
    ],
    targets: [
        .target(
            name: "Login",
            dependencies: [
                "Repositories",
            ]
        ),
    ]
)
