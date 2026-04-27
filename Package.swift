// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "cat-break",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "CatBreak", targets: ["CatBreak"]),
        .library(name: "CatBreakCore", targets: ["CatBreakCore"])
    ],
    targets: [
        .target(name: "CatBreakCore"),
        .executableTarget(
            name: "CatBreak",
            dependencies: ["CatBreakCore"],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "CatBreakCoreTests",
            dependencies: ["CatBreakCore"],
            path: "tests/CatBreakCoreTests"
        )
    ]
)
