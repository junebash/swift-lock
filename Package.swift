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
      dependencies: [],
      swiftSettings: [.unsafeFlags(["-Xfrontend", "-warn-concurrency"])]
    ),
    .testTarget(
      name: "LockTests",
      dependencies: ["Lock"],
      swiftSettings: [.unsafeFlags(["-Xfrontend", "-warn-concurrency"])]
    ),
  ]
)
