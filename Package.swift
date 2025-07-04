// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "StarCraftKit",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "StarCraftKit",
            targets: ["StarCraftKit"]
        ),
        .executable(
            name: "starcraft-cli",
            targets: ["StarCraftKitCLI"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-log", from: "1.5.3")
    ],
    targets: [
        .target(
            name: "StarCraftKit",
            dependencies: [
                .product(name: "Logging", package: "swift-log")
            ],
            swiftSettings: []
        ),
        .executableTarget(
            name: "StarCraftKitCLI",
            dependencies: [
                "StarCraftKit",
                .product(name: "ArgumentParser", package: "swift-argument-parser")
            ],
            swiftSettings: []
        ),
        .testTarget(
            name: "StarCraftKitTests",
            dependencies: ["StarCraftKit"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "StarCraftKitCLITests",
            dependencies: ["StarCraftKitCLI"]
        )
    ]
)