# Openterface Host

Experimental integration workspace for a unified Openterface desktop host
application with native, operating-system-specific frontends.

This repository currently preserves both existing applications as full-history
Git subtrees:

- `apps/macos` — the SwiftUI/AppKit macOS application
- `apps/qt` — the Qt Windows/Linux application

The immediate goal is not to rewrite either application. It is to establish a
portable, independently testable core and migrate one vertical slice at a time
while continuing to consume changes from both upstream projects.

## Repository layout

```text
apps/
  macos/       Existing native macOS application
  qt/          Existing Qt Windows/Linux application
core/          Portable application and hardware-domain logic
platform/      Host-OS adapters used by the portable core
shared/        Schemas, fixtures, protocol vectors, prompts, and assets
docs/          Architecture and migration documentation
scripts/       Upstream maintenance tooling
```

See [the architecture notes](docs/architecture/README.md) and
[the upstream synchronization guide](docs/upstream-sync.md) before moving code
between these areas.

## Getting started

Configure the official source remotes and check whether either imported tree is
behind:

```sh
./scripts/configure-upstreams.sh
./scripts/check-upstreams.sh
```

Or use the convenience target:

```sh
make check-upstreams
```

List the available baseline build and test commands with:

```sh
make help
```

The initial safety-net commands are:

```sh
make build-macos
make test-macos
make test-qt
```

See [Baseline builds and tests](docs/baseline-testing.md) for prerequisites,
scope, and the intentionally excluded hardware-dependent tests.

The two applications retain their original build systems and documentation:

- macOS: `apps/macos/README.md`
- Qt: `apps/qt/README.md` and `apps/qt/docs/BUILD.md`

## Project status

This is an experimental integration project and is not currently an official
TechxArtisanStudio repository. The imported applications remain subject to
their original licenses and attribution. New shared code in this repository is
licensed under AGPL-3.0, matching both source projects.
