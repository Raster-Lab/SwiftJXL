# History and provenance — SwiftJXL

## Documentation foundation — 17 September 2026

The owner chose four fresh repositories under Raster-Lab, with independent codecs, a common API and memory contract, MIT licensing and an optional adapter-based umbrella. The previous proposal for a new shared-foundation package, SwiftCompressionFamily 2.0.0, was superseded. The intended first stable release here is 2.0.0; no library version has been released or tagged by this foundation.

| Item | Recorded source |
| --- | --- |
| Predecessor | [Raster-Lab/JXLSwift](https://github.com/Raster-Lab/JXLSwift) |
| Default branch observed | main |
| Inspected source snapshot | [760697a54dd253da8e8466c3fd09ecf2c2d89aec](https://github.com/Raster-Lab/JXLSwift/commit/760697a54dd253da8e8466c3fd09ecf2c2d89aec) |
| Highest stable-shaped tag observed | [v1.4.0](https://github.com/Raster-Lab/JXLSwift/tree/v1.4.0) |
| Source-tree licence observed | MIT |
| Successor licence | MIT, for owner-authorised in-house material |
| Inspection date | 2026-09-17 |

The tag and the inspected branch snapshot are separate references; this record does not assert they resolve to the same commit. Before migrating a tagged baseline, resolve annotated tags to commits and record the exact chosen SHA. The pinned snapshot above was read for documentation preparation; it was not independently built or regression-tested in this task.

## Migration provenance requirements

The coding agent must record source repository, commit, original path and successor path for each migrated subsystem, and distinguish copied/adapted in-house material from new implementation. Record retained tests, fixture licences and explicit product/feature dispositions. Keep predecessor bug history accessible through links. Do not import old tags, rewrite predecessor history or imply all historical commits have been relicensed.

The owner states the implementation is in-house and has authorised MIT relicensing. Preserve accurate original copyright years and ownership. Audit any third-party dependencies, tools or fixtures separately. The MIT root licence is not authority to remove another party's notices.

The originals are intended to become maintenance projects while new development moves here. No predecessor settings, README, branch, release, licence or archive flag was changed during this documentation preparation. Maintenance announcements and downstream DICOMKit/Voxelia migration are separate work.

## Native transcoding source review — 18 September 2026

Re-inspected the same pinned predecessor snapshot for the owner-requested native transcoding instructions. [TRANSCODING.md](TRANSCODING.md) records concrete entry points, test assertions, known limitations and required successor corrections. Source presence/control flow were reviewed; no codec build, test or benchmark was executed. No predecessor files were changed.

## Swift 6.4 development upgrade — 19 September 2026

The owner assigned the successor upgrade before Milestone 2 and requested version increments. Starting from `423b8ae404ca5029a6a5fa1abe736d57dc8f0a96`, the candidate requires Swift tools 6.4 in Swift 6 language mode, advances shared contract 0.2.1 to 0.3.0 and advances the unreleased 2.0.0 target to 2.1.0 (`2.1.0-dev.1` development identifier). Platform floors, public API signatures, licensing and codec milestone scope are preserved. This is not a release/tag. The [upgrade record](Documentation/Engineering/Swift64/README.md) keeps current evidence separate from the earlier historical reports.

## OS 27 and CLI foundation — 19 September 2026

Apple platform floors are 26.0; contract 0.5.0 reverses the 0.4.0 raise to 27.0, which no released SDK, toolchain or CI runner can currently validate. Development version 2.1.0-dev.2, common contract 0.5.0. The standalone `swiftjxl` provides help/version/capabilities, five diagnostic levels and a matching section 1 manual installed/updated with the binary. Codec commands remain unavailable. Byte-order sample access uses explicit fixed-width integer conversion and does not raise the runtime floor. See [qualification and limitations](Documentation/Engineering/OS27CLI/README.md). Historical evidence and supplied documents remain unchanged.
## Apple floor restored to 26.0 — 20 September 2026

Contract 0.5.0 reverses the 0.4.0 raise of the Apple deployment floors to 27.0 and returns them to 26.0. Verification found that no generally available Xcode ships OS 27 SDKs, that no stable `macos-27` continuous-integration runner exists, and that Swift 6.4.0 rejects a 27.0 deployment target because its supported range ends at 26.5.x. Every OS 27 qualification claim was therefore unreproducible.

The raise was not an independent platform decision. Contract 0.4.0 adopted the OS-27-gated byte-order span overloads, and the floor moved so that they would compile. Contract 0.3.0 had already specified the correct treatment, explicit fixed-width integer endian conversion without raising the runtime floor, and that rule is restored. The compiler minimum returns to Swift 6.2 with Swift 6.4 retained as the qualified primary toolchain, because a manifest floor constrains consumer resolution and every current consumer resolves at 6.2.

Public signatures, ownership and fidelity semantics, milestone boundaries and Linux scope are unchanged. The OS 27 and Swift 6.4 records remain as history, marked superseded where they assert a platform baseline.

## Shared-storage rules refined from measurement — 20 September 2026

Contract 0.6.0 amends seven memory rules and adds one testing rule. Exploratory spikes ran the caller-storage question against all four predecessor codecs in both directions before any migration work, and every amendment comes from something those spikes measured or broke rather than from anticipated design.

The central finding reverses a standing assumption. `CopyPolicy.requireSharedStorage` is reachable in every codec, and each library reaches caller samples through exactly one stage, so pointing that stage at caller memory is small and local. What blocks the policy is the container each library exposes — `Data` per component, a packed `[UInt8]` with no row stride, a `[[Int]]` façade over an already-flat interior, or an initialiser that rejects any buffer that is not the packed frame size. A caller holding a padded plane cannot describe an image without first copying it. The `Image`/`ImageDescriptor` layer is therefore not packaging around working codecs; it is the Milestone 3 work.

The predecessor reads caller samples at one function and writes them at one stage, and its `ImageFrame.data` is a packed `[UInt8]` with no row stride. A caller-destination decode must stop before the frame is assembled; routing through the ordinary decode would build a full image and copy it in, which is the shortcut MEM-10 names. Workspace is `Int32` channel planes at twice the final frame.

Measured effects, all from a developer machine: live heap held after one JPEG 2000 decode fell from 16 MB in 6 blocks to 1 KB in 2 at 2048×2048, and for JPEG XL from 2 MB to nothing at 1024×1024; the JPEG 2000 output stage ran 9–35% faster writing the caller's plane; and on the encode side the copy a caller must make today costs 5.5 ms and 8 MB at 2048×2048 while the widening loop costs the same either way. Four defects surfaced during the work: inferred plane origins shearing padded multi-plane output, a shared encode that dropped its container wrapper and was caught only by comparing bytes rather than samples, a harness that bound an owner to storage released on the same line, and an address-sanitizer run reporting 100 MB live on a path holding nothing, which a probe traced to the sanitizer quarantining freed blocks.

The spikes are exploratory and are not proposed for merge into the predecessor repositories. No platform, milestone, release or CLI decision changes, and continuous integration remains blocked, so none of these results is a release gate.
