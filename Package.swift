// swift-tools-version: 6.0
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
		.package(url: "https://github.com/F8nUI/font-family.git", .upToNextMajor(from: "0.2.2"))
	],
    targets: [
        .target(
            name: "FoundationUI",
			dependencies: [.product(name: "FontFamily", package: "font-family")],
            path: "Sources/FoundationUI"
        ),
        .testTarget(
            name: "FoundationUITests",
            dependencies: ["FoundationUI"]),
    ]
)
