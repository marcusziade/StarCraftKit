// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "StarCraftKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(
            name: "StarCraftKit",
            targets: ["StarCraftKit"]
        )
    ],
    targets: [
        .target(
            name: "StarCraftKit"
        ),
        .testTarget(
            name: "StarCraftKitTests",
            dependencies: ["StarCraftKit"]
        ),
    ]
)
