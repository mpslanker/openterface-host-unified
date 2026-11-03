#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

component="${1:-}"
case "$component" in
    macos)
        prefix="apps/macos"
        remote="macos-upstream"
        branch="main"
        label="macOS"
        ;;
    qt)
        prefix="apps/qt"
        remote="qt-upstream"
        branch="main"
        label="Qt"
        ;;
    *)
        echo "Usage: $0 {macos|qt}" >&2
        exit 2
        ;;
esac

if [[ -n "$(git status --porcelain)" ]]; then
    echo "The working tree must be clean before synchronizing an upstream." >&2
    exit 1
fi

"$repo_root/scripts/configure-upstreams.sh" --quiet

remote_ref="refs/remotes/$remote/$branch"
git fetch --no-tags "$remote" "+refs/heads/$branch:$remote_ref"
latest="$(git rev-parse "$remote/$branch")"

if git merge-base --is-ancestor "$latest" HEAD; then
    echo "$label is already up to date at ${latest:0:12}."
    exit 0
fi

git subtree pull \
    --prefix="$prefix" \
    "$remote" \
    "$branch" \
    -m "Sync $label application from upstream at ${latest:0:12}"

echo "Synchronized $label through ${latest:0:12}."
echo "Review the merge and run the relevant native test suite before pushing."
