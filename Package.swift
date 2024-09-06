// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "InspectorA11y",
    platforms: [.iOS(.v16), .macOS(.v13)],
    products: [
        .library(
            name: "InspectorA11y",
            targets: ["InspectorA11y"]),
    ],
    targets: [
        .target(
            name: "InspectorA11y",
            dependencies: ["Csourcekitd"],
            resources: [
                .process("Resources")
            ]),
        .target(name: "Csourcekitd", dependencies: []),
        .testTarget(
            name: "InspectorA11yTests",
            dependencies: ["InspectorA11y"]),
    ]
)
