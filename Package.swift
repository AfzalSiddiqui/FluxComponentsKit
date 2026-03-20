// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "FluxComponentsKit",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "FluxComponentsKit",
            targets: ["FluxComponentsKit"]
        )
    ],
    dependencies: [
        .package(path: "../FluxTokensKit")
    ],
    targets: [
        .target(
            name: "FluxComponentsKit",
            dependencies: ["FluxTokensKit"]
        )
    ]
)
