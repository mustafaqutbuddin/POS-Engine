// swift-tools-version:5.3


import PackageDescription

let package = Package(
  name: "PosEngine",
  platforms: [
    .macOS(.v10_15), .iOS(.v14), .tvOS(.v14)
  ],
  products: [
    .library(
      name: "PosEngine",
      targets: ["PosEngine"]),
  ],
  targets: [
    .binaryTarget(
      name: "PosEngine",
      path: "./Sources/PosEngine.xcframework"
    )
  ]
)
