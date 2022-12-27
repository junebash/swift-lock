// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "swift-lock",
  products: [
    .library(
      name: "Lock",
      targets: ["Lock"]
    ),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "Lock",
      dependencies: []
    ),
    .testTarget(
      name: "LockTests",
      dependencies: ["Lock"]
    ),
  ]
)
