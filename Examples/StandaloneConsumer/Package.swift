// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftJXLStandaloneConsumer",
    platforms: [
        .macOS("26.0"), .iOS("26.0"), .tvOS("26.0"),
        .visionOS("26.0"), .watchOS("26.0")
    ],
    dependencies: [.package(path: "../..")],
    targets: [
        .executableTarget(
            name: "StandaloneConsumer",
            dependencies: [.product(name: "SwiftJXL", package: "SwiftJXL")]
        )
    ],
    swiftLanguageModes: [.v6]
)
