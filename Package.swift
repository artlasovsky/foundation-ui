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
            targets: ["FoundationUI"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "FoundationUI",
            dependencies: []),
        .testTarget(
            name: "FoundationUITests",
            dependencies: ["FoundationUI"]),
    ]
)
