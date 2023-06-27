// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DDDCore",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .singleNameLibrary(name: "DDDCore"),
        .singleNameLibrary(name: "Models"),
        .singleNameLibrary(name: "DatabaseClient")
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.53.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.5.0"),
        .package(url: "https://github.com/groue/GRDB.swift.git", branch: "master")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DatabaseClient",
            dependencies: [
                .product(name: "GRDB", package: "GRDB.swift"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                "Models"
            ]),
        .target(
            name: "DDDCore",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                "DatabaseClient",
                "Models"
            ]),
        .target(
            name: "Models",
            dependencies: []
        ),
        .testTarget(
            name: "DDDCoreTests",
            dependencies: ["DDDCore"]),
    ]
)

extension Product {
    static func singleNameLibrary(name: String) -> Product {
        return .library(name: name, targets: [name])
    }
}
