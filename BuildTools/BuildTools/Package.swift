// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BuildTools",
    dependencies: [
        .package(url: "https://github.com/yonaskolb/XcodeGen", from: "2.32.0"),
        .package(url: "https://github.com/realm/SwiftLint", from: "0.48.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.49.17"),
    ]
)
