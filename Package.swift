// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "StarCraftKit",
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
