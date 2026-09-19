// swift-tools-version: 6.4
// SPDX-License-Identifier: MIT
import PackageDescription

let package = Package(
    name: "SwiftJXL",
    platforms: [
        .macOS("27.0"), .iOS("27.0"), .tvOS("27.0"),
        .visionOS("27.0"), .watchOS("27.0")
    ],
    products: [.library(name: "SwiftJXL", targets: ["SwiftJXL"]),
               .executable(name: "swiftjxl", targets: ["SwiftJXLCLI"])],
    targets: [
        .target(name: "SwiftJXL"),
        .executableTarget(name: "SwiftJXLCLI", dependencies: ["SwiftJXL"]),
        .testTarget(name: "SwiftJXLTests", dependencies: ["SwiftJXL"])
    ],
    swiftLanguageModes: [.v6]
)
