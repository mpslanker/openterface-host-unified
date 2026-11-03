#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source_dir="$repo_root/apps/qt/tests/unit"
build_dir="${OPENTERFACE_QT_TEST_DIR:-$repo_root/build/qt-tests}"

if ! command -v cmake >/dev/null 2>&1; then
    echo "CMake is required to build the Qt unit tests." >&2
    exit 1
fi

cmake_args=(
    -S "$source_dir"
    -B "$build_dir"
    -DCMAKE_BUILD_TYPE=Debug
)

if command -v ninja >/dev/null 2>&1; then
    cmake_args+=( -G Ninja )
fi

cmake "${cmake_args[@]}"
cmake --build "$build_dir" --parallel
ctest --test-dir "$build_dir" --output-on-failure
