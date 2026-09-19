import Foundation
import SwiftJXL

enum MigrationCheckError: Error { case unexpectedResult }

@main
struct MigrationCheck {
    static func main() async throws {
        let limits = try SwiftJXL.ResourceLimits(
            maximumDecodedBytes: 1024, maximumMemoryBytes: 4096)
        let descriptor = try SwiftJXL.ImageDescriptor.greyscale16(
            width: 3, height: 2, meaningfulBits: 12, rowBytes: 8,
            limits: limits)
        let destination = try SwiftJXL.ImageDestination.allocate(
            descriptor: descriptor, limits: limits)
        let image = try destination.writeUInt16 { x, y in
            UInt16((y * 3 + x) * 819)
        }
        guard try image.sampleUInt16(x: 2, y: 1) == 4095 else {
            throw MigrationCheckError.unexpectedResult
        }
        let encoder = try SwiftJXL.Encoder()
        guard !encoder.capabilities.canEncode else {
            throw MigrationCheckError.unexpectedResult
        }
        do {
            _ = try await encoder.encode(
                image, options: .init(resourceLimits: limits))
            throw MigrationCheckError.unexpectedResult
        } catch let error as SwiftJXL.CodecError {
            guard error.category == .unsupportedFeature else { throw error }
        }
        let transcoder = try SwiftJXL.Transcoder()
        guard transcoder.capabilities.isEmpty else {
            throw MigrationCheckError.unexpectedResult
        }
        do {
            _ = try await transcoder.transcode(Data(), to: .jpegXL)
            throw MigrationCheckError.unexpectedResult
        } catch let error as SwiftJXL.CodecError {
            guard error.category == .unsupportedFeature else { throw error }
        }
        print("Migration preparation passed; codec operations remain unavailable.")
    }
}
