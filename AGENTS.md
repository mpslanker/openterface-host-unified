# Repository instructions

## Scope

This repository integrates two active upstream applications. Keep changes
incremental, reviewable, and attributable to their source project.

## Imported applications

- `apps/macos` is maintained as a Git subtree. Read
  `apps/macos/.claude/CLAUDE.md` before changing it.
- `apps/qt` is maintained as a Git subtree. Follow its local build and test
  documentation before changing it.
- Do not mass-format, reorganize, or mechanically rename imported code while
  syncing upstream work.
- Use `scripts/sync-upstream.sh`; do not replace either imported directory with
  a copied checkout.

## Shared architecture

- `core` must remain portable and independent of SwiftUI, AppKit, Qt, Windows
  APIs, Linux APIs, and other platform UI frameworks.
- `platform` owns operating-system integration and adapters.
- `shared` contains declarative data and cross-implementation fixtures, not UI
  or device access.
- New shared behavior should start with observable protocol vectors or golden
  tests that both frontends can consume.

## Verification

- Run `./scripts/check-upstreams.sh` after changing subtree maintenance logic.
- Run the relevant native application tests for changes under `apps`.
- Keep generated build products outside the source tree or in ignored root
  build directories.
