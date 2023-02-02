// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "IGJNetwork",
    platforms: [
        .macOS(.v10_12), .iOS(.v12)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "IGJNetwork",
            targets: ["IGJNetwork"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .exact("6.1.0")),
        .package(url: "https://github.com/JanGorman/Hippolyte", .exact("1.3.1")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "IGJNetwork",
            dependencies: ["RxSwift",
                           .product(name: "RxCocoa", package: "RxSwift")]
        ),
        .testTarget(
            name: "IGJNetworkTests",
            dependencies: ["IGJNetwork", "Hippolyte"],
            resources: [
                .process("sample/sample.json")
            ]),
    ]
)
