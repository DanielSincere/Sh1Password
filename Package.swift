// swift-tools-version:5.8

import PackageDescription

let package = Package(
  name: "Sh1Password",
  platforms: [
    .macOS(.v13),
  ],
  products: [
    .library(name: "Sh1Password", targets: ["Sh1Password"])
  ],
  dependencies: [
    .package(url: "https://github.com/DanielSincere/Sh.git", from: "1.3.0"),
  ],
  targets: [
    .target(name: "Sh1Password", dependencies: ["Sh"])
  ]
)
