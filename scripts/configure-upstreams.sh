#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

quiet=false
if [[ "${1:-}" == "--quiet" ]]; then
    quiet=true
fi

ensure_remote() {
    local name="$1"
    local expected_url="$2"

    if git remote get-url "$name" >/dev/null 2>&1; then
        local actual_url
        actual_url="$(git remote get-url "$name")"
        if [[ "$actual_url" != "$expected_url" ]]; then
            echo "Remote '$name' points to '$actual_url'; expected '$expected_url'." >&2
            echo "Refusing to overwrite an existing remote." >&2
            return 1
        fi
    else
        git remote add "$name" "$expected_url"
        if [[ "$quiet" == false ]]; then
            echo "Added $name -> $expected_url"
        fi
    fi

    git config "remote.$name.tagOpt" --no-tags
}

ensure_remote \
    macos-upstream \
    https://github.com/TechxArtisanStudio/Openterface_MacOS.git
ensure_remote \
    qt-upstream \
    https://github.com/TechxArtisanStudio/Openterface_QT.git

if [[ "$quiet" == false ]]; then
    git remote -v | grep -E '^(macos-upstream|qt-upstream)[[:space:]]'
fi
