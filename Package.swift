// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MLKit",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "MLKit", targets: ["MLKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/alexandertar/LASwift", from: "0.2.3"),
        .package(url: "https://github.com/Quick/Nimble.git", .upToNextMajor(from: "8.0.1")),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        // .package(name: "XGBoostSwift", url: "https://github.com/ddxgz/XGBoost.swift.git", from: "0.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "MLKit",
            dependencies: ["LASwift", .product(name: "Logging", package: "swift-log")]
        ),
        .testTarget(
            name: "MLKitTests",
            dependencies: ["MLKit", "LASwift", "Nimble"]
        ),
    ]
)
