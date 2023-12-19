// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FoundationUI",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "FoundationUI",
            targets: ["FoundationUI"])
    ],
    dependencies: [
    ],
    targets: [
        // Default theme – Native experience
        .target(
            name: "FoundationUI",
            dependencies: [],
            path: "Sources/FoundationUI"
        ),
        .testTarget(
            name: "FoundationUITests",
            dependencies: ["FoundationUI"]),
    ]
)
