// swift-tools-version: 6.4
import PackageDescription
let package = Package(name: "RemoteMigrationConsumer", platforms: [.macOS("27.0")],
 dependencies: [.package(url: "https://github.com/Raster-Lab/SwiftJXL.git", revision: "2df336334377b8c5b24450044724640716d29c00")],
 targets: [.executableTarget(name: "MigrationExample", dependencies: [.product(name: "SwiftJXL", package: "SwiftJXL")])],
 swiftLanguageModes: [.v6])
