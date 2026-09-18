# Change log

## Unreleased — application migration documentation, 2026-09-18

- Added [MIGRATION.md](MIGRATION.md) for humans and coding agents preparing JXLSwift applications: pinned API/product mappings, dependency and platform changes, a standalone preparation example, precision/ownership policies and rollout/rollback gates.
- Linked the guide from README, agent, contributor, implementation and transcoding entry points. Clarified Milestone 1 availability and separated future pixel-lossless encoding from original-JPEG-byte reconstruction. No codec implementation or release is added.

## Unreleased — Milestone 1 feasibility, 2026-09-18

- Final Milestone 1 review: prevent image publication when cancellation occurs inside provider sealing/validation; deterministic regressions and full checks pass.
- Added a standalone Swift 6.2-minimum package in Swift 6 language mode, local common API, checked descriptors, resource policies and owning storage with exclusive leases and immutable publication.
- Added native transcoder call shapes with empty capabilities and explicit unsupported errors. No codec algorithm, private codestream, real transcoder or CLI is implemented.
- Added 24 descriptor, ownership, concurrency, cancellation, resource and API tests plus an independent public consumer. Debug/release, AddressSanitizer and ThreadSanitizer checks passed locally with Xcode 27's Swift 6.4 toolchain; see [exact commands and limitations](Documentation/MILESTONE1.md).
- Added the coordinated ownership-contract refinement and retained predecessor provenance without copying codec code. Swift 6.2, Linux, other Apple runtime targets and codec interoperability remain unexecuted qualification gates.

## Unreleased — documentation foundation, 2026-09-17

- Defined the standalone SwiftJXL successor and intended first stable version 2.0.0.
- Added the common API, memory, platform, CLI, testing and performance specifications, codec-specific agent instructions, source provenance and MIT licence.
- No source migration, implementation, package manifest, executable test, binary or release tag is included.
- No runtime behaviour, support matrix or performance result is claimed as verified.

## Documentation clarification — contract 0.1.1, 2026-09-17

- Aligned the suite policy, README and agent handoff with the staged implementation plan: contract feasibility first, codec migration second, shared-storage integration third.
- Added explicit Milestone 1 test evidence and labelled the later codec delivery sections to prevent accidental expansion of the first task.
- Mirrored all seven common documents and regenerated their SHA-256 manifest across the four repositories. API/memory behaviour, platform floors, intended library versions and release gates are unchanged.
- Verified documentation consistency and links; no codec code or executable tests were added or run.

## Native transcoding instructions — contract 0.2.0, 2026-09-18

- Added a common native format-pair API/CLI pattern and explicit in-memory ownership, fidelity and testing requirements for SwiftJ2K and SwiftJXL.
- Distinguished sample-exact J2K ↔ HTJ2K conversion from original-JPEG-byte restoration through JPEG XL. Neither operation requires an umbrella or sibling codec dependency.
- Recorded predecessor implementation/test findings in the relevant repositories; kept Milestone 1 scoped to feasibility. No native transcode placeholder is required in SwiftJLS/SwiftJLI.
- Updated all seven shared documents and their SHA-256 manifest. This is documentation only; no source migration, codec execution or performance claim.

The foundation document version is 0.2.0. It is separate from the intended library version.
