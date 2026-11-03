# Upstream synchronization

The existing applications are imported as unsquashed Git subtrees. Their source
histories are ancestors of this repository, which lets Git determine whether an
official upstream commit is already integrated.

## Sources

| Component | Prefix | Official upstream | Imported baseline |
| --- | --- | --- | --- |
| macOS | `apps/macos` | `TechxArtisanStudio/Openterface_MacOS` | `956b5a4` (official `1838cff` plus Local Paste commits) |
| Qt | `apps/qt` | `TechxArtisanStudio/Openterface_QT` | `24220ab` |

The standalone forks remain the preferred place to prepare narrowly scoped
changes intended for either official repository.

## Merge policy

Pull requests containing an initial subtree import or a subtree synchronization
merge must reach the integration branch with **Create a merge commit**. Do not
squash-merge or rebase those PRs: doing so can discard the source parent
ancestry used by drift detection, future subtree pulls, and clean exports.

Ordinary feature and documentation pull requests that do not contain subtree
merge commits may follow the project's normal merge policy.

## Configure and check

```sh
./scripts/configure-upstreams.sh
./scripts/check-upstreams.sh
```

The check fetches only each official `main` branch, does not merge anything, and
returns a nonzero status when new upstream commits are missing.

## Synchronize one application

Start from a clean integration branch, then run:

```sh
./scripts/sync-upstream.sh macos
# or
./scripts/sync-upstream.sh qt
```

The script fetches the selected official `main` branch and performs an
unsquashed `git subtree pull`. Review the resulting merge, resolve conflicts in
the affected application, run its native tests, and open an integration PR. It
does not push anything.

## Contribute an integration change upstream

For straightforward fixes, make and test the change in the standalone fork and
submit it upstream first. Pull the accepted commit back through the normal sync
workflow.

If a fix was developed inside the integration repository, create an inspectable
export branch before pushing it to a fork:

```sh
git subtree split --prefix=apps/macos -b export/macos-change
# Inspect the branch, then push it to your macOS fork.

git subtree split --prefix=apps/qt -b export/qt-change
# Inspect the branch, then push it to your Qt fork.
```

Never force-push an exported subtree directly onto a fork's `main` branch.

## When code has moved into the shared core

Upstream changes to a superseded implementation cannot be merged mechanically.
Review their behavior, add or update a language-neutral test vector, and port
the intent into the core. Record that decision in the integration PR so the
relationship remains auditable.
