// swift-tools-version: 6.4
import PackageDescription
let package = Package(name: "RemoteMigrationConsumer", platforms: [.macOS("26.0")],
 dependencies: [.package(url: "https://github.com/Raster-Lab/SwiftJXL.git", revision: "00cac8f4e8b1aa6864c38a9ed6b8f79c20fe6366")],
 targets: [.executableTarget(name: "MigrationExample", dependencies: [.product(name: "SwiftJXL", package: "SwiftJXL")])],
 swiftLanguageModes: [.v6])
