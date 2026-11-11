// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KeyringAccess",
    platforms: [.macOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SecretService",
            targets: ["SecretService"]),
        .library(
            name: "KeyringAccess",
            targets: ["KeyringAccess"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/wendylabsinc/dbus.git", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", .upToNextMajor(from: "1.10.0")),
        .package(url: "https://github.com/apple/swift-log", from: "1.6.0"),
        .package(url: "https://github.com/amethystsoft/big-num", .upToNextMajor(from: "1.0.0")),
        .package(
            url: "https://github.com/swiftlang/swift-docc-plugin",
            from: "1.0.0"
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SecretService",
            dependencies: [
                .product(name: "DBUS", package: "dbus"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
                .product(name: "BigNum", package: "big-num")
            ]
        ),
        .target(
            name: "KeyringAccess",
            dependencies: [
                "SecretService",
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "SecretServiceTests",
            dependencies: [
                "SecretService",
                .product(name: "Logging", package: "swift-log")
            ]
        ),
        .testTarget(
            name: "KeyringAccessTests",
            dependencies: [
                "KeyringAccess"
            ]
        )
    ]
)
