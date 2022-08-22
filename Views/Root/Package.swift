// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "Root",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        .library(
            name: "Root",
            targets: ["Root"]
        ),
    ],
    dependencies: [
        .package(path: "../Activity"),
        .package(path: "../Channel"),
        .package(path: "../Clip"),
        .package(path: "../Home"),
        .package(path: "../Login"),
        .package(path: "../User"),
    ],
    targets: [
        .target(
            name: "Root",
            dependencies: [
                "Activity",
                "Channel",
                "Clip",
                "Home",
                "Login",
                "User",
            ]
        ),
    ]
)
