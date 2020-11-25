// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RocketNetworking",
    platforms: [
        .iOS(.v12),
        .watchOS(.v6),
        .macOS(.v10_15),
        .tvOS(.v11)
    ],
    products: [
        .library(
            name: "RocketNetworking",
            targets: ["RocketNetworking"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RocketNetworking",
            dependencies: []),
        .testTarget(
            name: "RocketNetworkingTests",
            dependencies: ["RocketNetworking"]),
    ]
)
