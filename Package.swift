// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeyRun",
    platforms: [.macOS("10.15")],
    products: [
        .library(name: "core", targets: ["KeyRun_core"]),
        .executable(name: "origin", targets: ["KeyRun_origin"]),
        .executable(name: "ja", targets: ["KeyRun_ja"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "KeyRun_core",
            dependencies: []),
        .target(
            name: "KeyRun_origin",
            dependencies: ["KeyRun_core"]),
        .target(
            name: "KeyRun_ja",
            dependencies: ["KeyRun_core"]),
        .testTarget(
            name: "KeyRunTests",
            dependencies: ["KeyRun_core"]),
    ]
)
