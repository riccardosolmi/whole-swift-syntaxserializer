// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "SwiftSyntaxSerializer",
    products: [
      .executable(name: "SwiftSyntaxSerializer", targets: ["SwiftSyntaxSerializer"]),
      .library(name: "SwiftSourcePersistence", targets: ["SwiftSourcePersistence"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.1")),
        .package(url: "https://github.com/apple/swift-syntax.git", .exact("0.50100.0")),
        .package(url: "https://github.com/apple/swift-format.git", .branch("swift-5.1-branch")),
        .package(url: "https://github.com/apple/swift-package-manager.git", .exact("0.5.0")),
    ],
    targets: [
        .target(
            name: "SwiftSourcePersistence",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftFormat", package: "swift-format")]),
        .target(
            name: "SwiftSyntaxSerializer",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                "SwiftSourcePersistence",
            ]),
        .testTarget(
            name: "SwiftSyntaxSerializerTests",
            dependencies: [
                "SwiftSourcePersistence",
            ]),
    ]
)
