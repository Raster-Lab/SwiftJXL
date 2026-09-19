// swift-tools-version: 6.4
import PackageDescription
let package = Package(
    name: "RemoteConsumerSwiftJXL",
    platforms: [.macOS("27.0")],
    dependencies: [.package(url: "https://github.com/Raster-Lab/SwiftJXL.git", revision: "6ff68a6ee4c9051f19f405ced7a683eb228deff1")],
    targets: [.executableTarget(name: "Consumer", dependencies: [.product(name: "SwiftJXL", package: "SwiftJXL")])],
    swiftLanguageModes: [.v6]
)
