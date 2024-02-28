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
        ),
        .executable(name: "StarCraftCLI", targets: ["StarCraftCLI"]),
    ],
    targets: [
        .target(
            name: "StarCraftKit"
        ),
        .target(name: "StarCraftCLI", dependencies: ["StarCraftKit"]),
        .testTarget(
            name: "StarCraftKitTests",
            dependencies: ["StarCraftKit"]
        ),
    ]
)
