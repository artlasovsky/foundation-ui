// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TrussUI",
    platforms: [
        .macOS(.v12),
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "TrussUI",
            targets: ["TrussUI"])
    ],
    dependencies: [
    ],
    targets: [
        // Default theme – Native experience
        .target(
            name: "TrussUI",
            dependencies: [],
            path: "Sources/TrussUI"
        ),
        .testTarget(
            name: "TrussUITests",
            dependencies: ["TrussUI"]),
    ]
)
