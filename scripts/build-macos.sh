#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
project="$repo_root/apps/macos/openterface.xcodeproj"
derived_data="${OPENTERFACE_MACOS_BUILD_DIR:-$repo_root/build/macos-release}"

if ! command -v xcodebuild >/dev/null 2>&1; then
    echo "xcodebuild is required to build the macOS application." >&2
    exit 1
fi

mkdir -p "$derived_data"

xcodebuild build \
    -quiet \
    -project "$project" \
    -scheme openterface \
    -configuration Release \
    -destination "generic/platform=macOS" \
    -derivedDataPath "$derived_data" \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO

echo "macOS application build completed:"
echo "  $derived_data/Build/Products/Release/openterface.app"
