// swift-tools-version:5.10

import PackageDescription

let package = Package(
    name: "SQLizer",
    platforms: [.iOS(.v15), .macOS(.v12), .tvOS(.v15), .visionOS(.v1)],
    products: [
        .executable(name: "sqlize", targets: ["sqlize"]),
        .library(name: "SQLizer", targets: ["SQLizer"])
    ],
    targets: [
        .executableTarget(
            name: "sqlize",
            dependencies: ["SQLizer"]),
        .target(
            name: "SQLizer",
            dependencies: ["libsqlite3"]),
        .systemLibrary(
            name: "libsqlite3"),
        .testTarget(
            name: "SQLizerTests",
            dependencies: ["SQLizer"]),
    ]
)
