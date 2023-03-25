// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WindowOverlay",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "WindowOverlay",
            targets: ["WindowOverlay"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/divadretlaw/WindowSceneReader", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "WindowOverlay",
            dependencies: ["WindowSceneReader"]
        ),
    ]
)
