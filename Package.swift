// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "flux-ios-foundation",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "flux-ios-foundation",
            targets: ["flux-ios-foundation"]
        )
    ],
    dependencies: [
        .package(path: "../flux-ios-ds")
    ],
    targets: [
        .target(
            name: "flux-ios-foundation",
            dependencies: [
                .product(name: "flux-ios-ds", package: "flux-ios-ds")
            ],
            path: "Sources/flux-ios-foundation"
        )
    ]
)
