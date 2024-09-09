// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "InspectorA11y",
  platforms: [.iOS(.v17), .macOS(.v13)],
  products: [
    .library(
      name: "InspectorA11yCore",
      targets: ["InspectorA11yCore"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
  ],
  targets: [
    .executableTarget(
      name: "InspectorA11y",
      dependencies: [
        "InspectorA11yCore",
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]),
    .target(name: "InspectorA11yCore", dependencies: ["Csourcekitd"], resources: [
      .process("Resources")
    ]),
    .target(name: "Csourcekitd", dependencies: []),
    .testTarget(
      name: "InspectorA11yCoreTests",
      dependencies: ["InspectorA11yCore"])
  ]
)
