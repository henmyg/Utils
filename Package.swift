// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Utils", targets: ["Utils"]),
        .library(name: "UiUtils", targets: ["UiUtils"]),
        .library(name: "CombineUtils", targets: ["CombineUtils"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Utils",
            dependencies: []),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]),
        .target(name: "UiUtils"),
        .target(name: "CombineUtils"),
        .testTarget(
            name: "CombineUtilsTests",
            dependencies: ["CombineUtils"])
    ]
)
