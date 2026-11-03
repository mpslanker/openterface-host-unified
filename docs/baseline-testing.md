# Baseline builds and tests

The baseline safety net delegates to the imported applications without changing
their build systems. Generated output is stored below the ignored root `build/`
directory.

## macOS application build

Requirements:

- macOS with Xcode and command-line tools selected;
- network access when Swift Package Manager dependencies are not cached.

Run:

```sh
make build-macos
```

This produces an unsigned Release application suitable for compilation
verification. Signing, notarization, and DMG packaging remain owned by the
imported macOS release workflow.

Override the generated-data location when necessary:

```sh
OPENTERFACE_MACOS_BUILD_DIR=/tmp/openterface-build make build-macos
```

## Deterministic macOS unit tests

Run:

```sh
make test-macos
```

The baseline selects tests for Local Paste, keyboard release behavior, and RDP
authentication/DER structures. It excludes tests that require:

- physical HID or video hardware;
- a live RDP or VNC server;
- camera, Accessibility, or screen-capture permission;
- interactive OCR or UI behavior.

This is intentionally not presented as the complete upstream test suite. The
selection should shrink only when hardware and integration tests have explicit
plans, fixtures, or CI environments.

`WCHFlashingTests.swift` contains deterministic-looking protocol tests but is
not currently a member of the imported Xcode test target, so the baseline does
not claim or silently depend on it. It can be enabled upstream when that project
decides how the file should be maintained.

## Standalone Qt unit tests

Requirements:

- CMake 3.16 or newer;
- Qt 6 Core and Test development packages;
- Ninja is optional and used automatically when available.

On Ubuntu 24.04:

```sh
sudo apt-get install cmake ninja-build qt6-base-dev
```

On macOS with Homebrew:

```sh
brew install qt
```

Run:

```sh
make test-qt
```

This configures `apps/qt/tests/unit` directly, avoiding the FFmpeg, GStreamer,
USB, packaging, and display dependencies required by the complete Qt app. The
existing tests cover EDID identity parsing and device-information semantics.

Full Windows and Linux application builds remain in the imported Qt workflows
until equivalent integration infrastructure is deliberately migrated to the
root project.

## CI

`.github/workflows/baseline.yml` runs the deterministic macOS tests and unsigned
Release build on a macOS runner, plus the standalone Qt unit tests on Ubuntu.
It does not sign, publish, install drivers, access physical hardware, or create
release artifacts.
