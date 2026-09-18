// Copyright (c) 2026 Raster Images Private Limited
// SPDX-License-Identifier: MIT

import Foundation
import Synchronization
import Testing
import SwiftJXL

@Suite("Native JPEG reconstruction API feasibility")
struct NativeTranscoderTests {
    @Test("Targets are not mistaken for implemented capabilities")
    func noAdvertisedCodec() throws {
        let transcoder = try Transcoder(configuration: TranscoderConfiguration())
        #expect(transcoder.capabilities.pairs.isEmpty)
        #expect(transcoder.capabilities.backends.isEmpty)
        #expect(Set(TranscodeTarget.allCases) == [.jpegXL, .jpeg])
    }

    @Test("Native options preserve ownership and ancillary bytes by default")
    func preservingDefaults() {
        let options = TranscodeOptions()
        #expect(options.copyPolicy == .requireSharedStorage)
        #expect(options.metadataPolicy == .preserve)
        #expect(options.resourceLimits.maximumInputBytes > 0)
        #expect(options.resourceLimits.maximumOutputBytes > 0)
        #expect(options.progress == nil)
    }

    @Test("Neither native direction returns fabricated compressed bytes", arguments: TranscodeTarget.allCases)
    func unimplementedDirection(_ target: TranscodeTarget) async throws {
        let transcoder = try Transcoder()
        // Deliberately only a marker prefix: no claim that this is a valid JPEG
        // fixture or that an input parser has been migrated.
        let input = Data([0xff, 0xd8])
        do {
            _ = try await transcoder.transcode(input, to: target)
            Issue.record("An unimplemented native operation returned success")
        } catch let error as CodecError {
            #expect(error.category == .unsupportedFeature)
        }
    }

    @Test("Input admission rejects before any native operation")
    func boundedInput() async throws {
        let transcoder = try Transcoder()
        let limits = try ResourceLimits(maximumInputBytes: 2)
        do {
            _ = try await transcoder.transcode(
                Data([0xff, 0xd8, 0xff]), to: .jpegXL,
                options: TranscodeOptions(resourceLimits: limits)
            )
            Issue.record("Input beyond the configured limit was accepted")
        } catch let error as CodecError {
            #expect(error.category == .resourceLimitExceeded)
        }
    }

    @Test("Discard is incompatible with original-byte preservation")
    func noMetadataDiscard() async throws {
        let transcoder = try Transcoder()
        do {
            _ = try await transcoder.transcode(
                Data(), to: .jpeg,
                options: TranscodeOptions(metadataPolicy: .discardAncillary)
            )
            Issue.record("Reconstruction accepted ancillary byte discard")
        } catch let error as CodecError {
            #expect(error.category == .unsupportedFeature)
        }
    }

    @Test("Failure emits no successful or fabricated progress")
    func noProgressOnUnsupported() async throws {
        let updates = NativeProgressCounter()
        let transcoder = try Transcoder()
        let options = TranscodeOptions(progress: { _ in
            updates.record()
        })
        do {
            _ = try await transcoder.transcode(Data(), to: .jpegXL, options: options)
            Issue.record("An unimplemented operation returned success")
        } catch let error as CodecError {
            #expect(error.category == .unsupportedFeature)
        }
        #expect(updates.value == 0)
    }

    @Test("Cancellation keeps Swift CancellationError identity")
    func cancellationPrecedesAdmission() async throws {
        let transcoder = try Transcoder()
        let limits = try ResourceLimits(maximumInputBytes: 1)
        let task = Task {
            withUnsafeCurrentTask { $0?.cancel() }
            do {
                _ = try await transcoder.transcode(
                    Data([0, 1]), to: .jpeg,
                    options: TranscodeOptions(resourceLimits: limits, metadataPolicy: .discardAncillary)
                )
                return false
            } catch is CancellationError {
                return true
            } catch {
                return false
            }
        }
        #expect(await task.value)
    }
}

private final class NativeProgressCounter: Sendable {
    private let count = Mutex(0)
    var value: Int { count.withLock { $0 } }
    func record() { count.withLock { $0 += 1 } }
}
