// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeedbackAPIModel",
    products: [
        .library(
            name: "APIModel",
            targets: ["APIModel"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "APIModel",
			dependencies: [],
			path: "Sources")
    ]
)
