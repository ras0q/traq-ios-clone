// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Content",
    platforms: [
        .iOS(.v14),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Content",
            targets: ["Content"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../Activity"),
        .package(path: "../Channel"),
        .package(path: "../Clip"),
        .package(path: "../Home"),
        .package(path: "../User"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Content",
            dependencies: [
                "Activity",
                "Channel",
                "Clip",
                "Home",
                "User",
            ]
        ),
        .testTarget(
            name: "ContentTests",
            dependencies: ["Content"]
        ),
    ]
)
