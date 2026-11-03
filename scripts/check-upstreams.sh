#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

"$repo_root/scripts/configure-upstreams.sh" --quiet

status=0

check_upstream() {
    local component="$1"
    local remote="$2"
    local branch="$3"
    local remote_ref="refs/remotes/$remote/$branch"

    git fetch --quiet --no-tags \
        "$remote" \
        "+refs/heads/$branch:$remote_ref"

    local latest
    latest="$(git rev-parse "$remote/$branch")"

    if git merge-base --is-ancestor "$latest" HEAD; then
        echo "$component: up to date at ${latest:0:12}"
        return
    fi

    local missing
    missing="$(git rev-list --count "$latest" --not HEAD)"
    echo "$component: $missing upstream commit(s) not integrated; latest is ${latest:0:12}" >&2
    if [[ -n "${GITHUB_ACTIONS:-}" ]]; then
        echo "::error title=$component upstream drift::$missing commit(s) from $remote/$branch are not integrated"
    fi
    status=1
}

check_upstream macOS macos-upstream main
check_upstream Qt qt-upstream main

exit "$status"
