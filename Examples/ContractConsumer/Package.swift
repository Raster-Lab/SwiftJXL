// swift-tools-version: 6.4
// SPDX-License-Identifier: MIT
import PackageDescription

let package = Package(
    name: "ContractConsumer",
    platforms: [.macOS("26.0")],
    dependencies: [.package(path: "../..")],
    targets: [
        .executableTarget(
            name: "ContractConsumer",
            dependencies: [.product(name: "SwiftJXL", package: "SwiftJXL")]
        )
    ],
    swiftLanguageModes: [.v6]
)
