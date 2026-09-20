# Milestone 1 — API and storage feasibility

**Final validation after review:** 25 Swift Testing tests passed in each of debug, release, AddressSanitizer and ThreadSanitizer; every command and the independent consumer exited 0. The final source hashes, complete command lines, logs and XML are in [Validation/final](Validation/final). Earlier tables below record the preceding implementation snapshot; this final evidence supersedes their test counts and source fingerprints.


This change implements the first assigned milestone only. It does not implement JPEG XL compression, decompression, inspection, JPEG reconstruction, a CLI or a real transcoder. Codec capabilities remain empty and codec operations reject with defined errors. Synthetic storage tests are contract evidence, not JPEG XL interoperability evidence.

## Revision and provenance

- Successor foundation: `d9c691d1de8bf3f545af4b220182864c6809caca`.
- Work branch: `codex/milestone-1-contract`.
- Predecessor: Raster-Lab/JXLSwift at `760697a54dd253da8e8466c3fd09ecf2c2d89aec`.
- Contract baseline: 0.2.0; implemented refinement: 0.2.1. The seven mirrored documents and `COMMON_CONTRACT_SHA256.txt` record the coordinated Milestone 1 lease, admission and preflight semantics.
- Implementation and tests are new MIT-licensed code; no predecessor codec source or external fixture is copied.

The pinned predecessor `Package.swift`, `CLAUDE.md`, `Sources/JXLSwift/Codec/ImageFrame.swift` and `Sources/JXLSwift/Codec/AsyncOverloads.swift` were inspected. Its image uses mutable, tightly interleaved `[UInt8]` storage, `precondition` validation and unchecked allocation products; its async methods forward to synchronous methods on the caller's executor. These conventions are replaced by validated owning storage and the explicit concurrency contract. The predecessor's Apple-only platform restriction and local J2K checkout guidance are superseded by the successor suite policy. Root `AGENTS.md` is absent at that snapshot; `CLAUDE.md` supplies predecessor guidance.

The predecessor library, `JXLTool` executable aliases (`jxl-tool`, `jxl`), `JXLPerfC` optional kernel target, Modular/VarDCT codecs, JPEG reconstruction, container/entropy code and old tests remain migration candidates for Milestones 2–4. None is removed from the predecessor or advertised as implemented here. Predecessor codec regression/oracle builds are deferred to the migration baseline milestone: this milestone imports no codec subsystem.

## Reproducing local validation

Run `bash Scripts/validate.sh` from the repository root. It selects Xcode through the process-local `DEVELOPER_DIR` and never changes the computer's `xcode-select` preference. Command output is retained under `.build/evidence/`. Debug/release, consumer, AddressSanitizer and ThreadSanitizer commands are deliberately separate; a failing command stops the script.

The local host was macOS 27.0 (`26A428`), arm64. Xcode was 27.0 (`27A266a`), Apple Swift 6.4 (`swiftlang-6.4.0.34.1`, clang `2100.3.34.1`); package manifests require Swift 6.2 and Swift 6 language mode. A compiler declaring 6.2 as its tools minimum is not evidence of an executed Swift 6.2 compiler build.

All final commands below ran on 18 September 2026 after the caller metadata/admission-budget correction, with these process-local environment values:

```sh
export DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer
export CLANG_MODULE_CACHE_PATH="$PWD/.build/module-cache"
export SWIFTPM_MODULECACHE_OVERRIDE="$CLANG_MODULE_CACHE_PATH"
```

| Command | Exit | Observed result |
| --- | --- | --- |
| `xcrun swift build --disable-sandbox --build-system native -c debug` | 0 | Library build passed |
| `xcrun swift test --disable-sandbox --build-system native -c debug` | 0 | 24 Swift Testing tests passed, 0 failed, 0 skipped |
| `xcrun swift build --disable-sandbox --build-system native -c release` | 0 | Optimised library build passed |
| `xcrun swift test --disable-sandbox --build-system native -c release` | 0 | 24 Swift Testing tests passed, 0 failed, 0 skipped |
| `xcrun swift run --disable-sandbox --build-system native --package-path Examples/ContractConsumer ContractConsumer` | 0 | Independent consumer compiled and ran |
| `xcrun swift test --disable-sandbox --build-system native --sanitize=address --scratch-path .build/asan` | 0 | 24 tests passed; no AddressSanitizer finding |
| `xcrun swift test --disable-sandbox --build-system native --sanitize=thread --scratch-path .build/tsan` | 0 | 24 tests passed; no ThreadSanitizer finding |

The test runner's XCTest compatibility section reports zero tests because these cases use Swift Testing; the subsequent Swift Testing result reports the actual 24. Swift Testing emitted separately suffixed `*-swift-testing.xml` reports for the release and sanitizer runs; these and final logs are archived under `Validation/`. [VALIDATION.json](VALIDATION.json) records the executed-command summary and environment in machine-readable form; raw runner logs remain in `.build/evidence/`.

Initial attempts and limits are preserved rather than counted as passes:

- The first default-cache SwiftPM command failed because the agent sandbox could not write `~/.cache/clang`. Moving compiler caches to `.build/module-cache` and disabling SwiftPM's nested manifest sandbox resolved it. This changes build tooling only, not package compiler flags or runtime protections.
- Xcode 27's default `swiftbuild` engine built the debug and release library and ran 23 tests before the final metadata-budget regression was added. Its release test packaging failed at `dsymutil` with `Operation not permitted`. The complete final validation therefore used Xcode's compiler with SwiftPM's `native` engine. Xcode 27 warns this engine is deprecated; this is a local sandbox workaround, not a package requirement.
- `xcodebuild -list -workspace .build/Headless.xcworkspace -clonedSourcePackagesDirPath .build/SourcePackages` exited 66, rejecting a valid workspace as “not a workspace file” amid file-type service warnings. Direct `xcodebuild` project/test validation is unavailable in this sandbox. Compilation and test execution still ran headlessly using the installed Xcode compiler, SDK and `xcrun`.

## Additional Apple SDK compilation

After final source changes, all SwiftJXL source files also compiled successfully with the installed Xcode 27.0 SDKs for each of the following deployment-26.0 targets. These are module-emission checks, without linking, launching a simulator or running device tests.

| SDK | Target triple | Exit |
| --- | --- | --- |
| macOS 27.0 | `x86_64-apple-macosx26.0` | 0 |
| iOS 27.0 | `arm64-apple-ios26.0` | 0 |
| iOS Simulator 27.0 | `arm64-apple-ios26.0-simulator` | 0 |
| tvOS 27.0 | `arm64-apple-tvos26.0` | 0 |
| tvOS Simulator 27.0 | `arm64-apple-tvos26.0-simulator` | 0 |
| visionOS 27.0 | `arm64-apple-xros26.0` | 0 |
| visionOS Simulator 27.0 | `arm64-apple-xros26.0-simulator` | 0 |
| watchOS 27.0 | `arm64_32-apple-watchos26.0` | 0 |
| watchOS Simulator 27.0 | `arm64-apple-watchos26.0-simulator` | 0 |

The invocation was `xcrun swiftc -parse-as-library -emit-module -swift-version 6 -strict-concurrency=complete -target <triple> -sdk <installed SDK path> -module-cache-path <writable cache> -module-name SwiftJXL -emit-module-path <output> Sources/SwiftJXL/*.swift`. Exact expanded command lines are recorded in [VALIDATION.json](VALIDATION.json). No compiler warning or error was emitted by these nine commands. This does not qualify native Intel execution, device behaviour or other runtimes.

## Behaviour and ownership evidence

The local `StorageWriteLease` is a fresh opaque UUID value; its identity alone authorises no access. `OwnedImageStorage` enforces the shared reservation/borrow/seal/abort lifecycle behind `Synchronization.Mutex`. The provider rejects forged, stale, concurrent and re-entrant write attempts. No implementation type uses unchecked Sendable, stores an escaped buffer pointer or adopts temporary array/Data storage. The sealed owner holds immutable bytes, and `Image` retains an adapter owner until its last reader releases it.

- [DescriptorTests.swift](../Tests/SwiftJXLTests/DescriptorTests.swift): packed/padded odd dimensions, final-row capacity, precision, overflow, alignment, overlap and semantic metadata; 88 deterministic offset/stride mutations are checked against independently stated valid-layout conditions.
- [StorageTests.swift](../Tests/SwiftJXLTests/StorageTests.swift): lease misuse, abort, zeroed padding, fresh/shared allocation identities, short providers, early caller release, exactly one adapter deinitialisation, 16 concurrent readers and attempted concurrent writes using copied tokens.
- [APITests.swift](../Tests/SwiftJXLTests/APITests.swift): every required codec call shape rejects honestly, failure before a write preserves an unused destination, partial-write cancellation invalidates it, invalid sample values are rejected, and custom pixel/metadata memory budgets are enforced.
- [Public consumer](../Examples/ContractConsumer/Sources/ContractConsumer/Consumer.swift): no `@testable` import, no sibling module and no package dependency beyond this local package. Remote URL/versioned consumption is a separate unexecuted gate.

Fixtures are new MIT-licensed synthetic generators embedded in these tests; no third-party files or patient data are used. Known vectors include `[0, 4095, 1, 2048, 17, 4094]`, full UInt16 extrema and a deterministic 3×2 ramp. Expected values are checked independently of any decoder, because no decoder exists yet.

The implementation allocates zero-initialised sample storage and transfers its array into an immutable owner on seal without a byte-copy loop. Tests observe writes and later reads through matching allocation identities and retain exact sample values. This repository does not yet instrument allocator internals or claim real-codec zero-copy performance. Reports leave unmeasured allocation counts, memory peaks and timings `nil`. No codec hot path changed, so no codec throughput or regression benchmark is claimed. Raw fill closures remain an explicitly unsafe caller boundary: pointers must not escape or span `await`, and callers must bound work inside the closure. Codec deadlines/progress scheduling are deferred with the actual algorithms.

## Coverage boundaries

Linux arm64/x86_64, native macOS Intel, physical Apple devices, Swift 6.2 runtime/compiler qualification, fresh remote URL consumption, codec oracle tests, parser fuzz campaigns and codec benchmarks remain unexecuted gates. There are no codec parsers or kernels in this milestone. No throughput, compression ratio, GPU support, decoded-sample preservation or JPEG byte-reconstruction claim follows from these synthetic tests.

## Final publication-cancellation correction

Independent review found that cancellation inside an external provider's sealing or validation callback could occur after the last cancellation check. The write now constructs its owning image, checks task cancellation immediately before returning, and publishes only on success. A deterministic parameterised regression cancels during `finishAndSeal` and during the returned read-owner validation borrow. Both cases throw `CancellationError` and permanently prevent destination reuse. If the provider has already sealed, its private read owner is discarded without publishing an Image; cleanup cannot reopen that sealed allocation. No workers or pointers outlive the operation.

All final test runs explicitly select Swift Testing with `--disable-xctest`: these packages contain no XCTest cases. The first final-validation attempt executed every Swift Testing case successfully but exited 1 because Xcode 27's empty XCTest compatibility bundle could not be loaded from the separate scratch directory. That failed runner log is retained; the corrected invocation runs all actual tests and returns 0. This is runner selection, not a test skip or suppression of a failing test. All nine Apple SDK module checks were repeated after the source fix and passed.
