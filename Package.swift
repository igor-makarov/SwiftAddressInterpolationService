// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InterpolationService",
    dependencies: [
        .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.4.0")),
        .package(url: "https://github.com/igor-makarov/SwiftAddressInterpolation.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "InterpolationService",
            dependencies: [
                "AddressInterpolation",
                "Swifter",
            ]),
    ]
)
