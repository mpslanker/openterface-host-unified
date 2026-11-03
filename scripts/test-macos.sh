#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project="$repo_root/apps/macos/openterface.xcodeproj"
derived_data="${OPENTERFACE_MACOS_TEST_DIR:-$repo_root/build/macos-tests}"

if ! command -v xcodebuild >/dev/null 2>&1; then
    echo "xcodebuild is required to run the macOS test suite." >&2
    exit 1
fi

mkdir -p "$derived_data"

# These suites are deterministic and do not require a KVM, camera, live RDP/VNC
# server, Accessibility permission, or interactive UI. Keep this list explicit
# until the imported project separates hardware tests into an Xcode test plan.
test_selection=(
    -only-testing:openterfaceTests/LocalPasteTests
    -only-testing:openterfaceTests/KeyboardInputReleaseTests
    -only-testing:openterfaceTests/RDPNTLMNegotiateTests
    -only-testing:openterfaceTests/RDPNTLMChallengeTests
    -only-testing:openterfaceTests/RDPNTLMAuthenticateTests
    -only-testing:openterfaceTests/RDPAuthenticateOffsetTests
    -only-testing:openterfaceTests/SPNEGOStructureTests
    -only-testing:openterfaceTests/TSRequestDERTests
)

xcodebuild test \
    -quiet \
    -project "$project" \
    -scheme openterface \
    -destination "platform=macOS" \
    -derivedDataPath "$derived_data" \
    CODE_SIGNING_ALLOWED=NO \
    "${test_selection[@]}"
