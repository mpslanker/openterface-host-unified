# Architecture direction

## Objective

Build one Openterface host product with multiple native frontends and a shared,
portable core. Preserve the native macOS user experience and the established Qt
Windows/Linux application while eliminating duplicated hardware and product
policy logic.

## Dependency direction

```text
macOS frontend ─┐
                ├─> portable core <─> shared schemas and test vectors
Qt frontend ────┘         │
                          v
                  platform adapter interfaces
                          │
               macOS / Windows / Linux adapters
```

The portable core owns decisions and state machines. Platform adapters perform
I/O. Frontends present state and translate user intent.

## Migration principles

1. Preserve working applications throughout the migration.
2. Extract behavior only after defining its observable inputs and outputs.
3. Add golden tests before replacing either implementation.
4. Avoid exposing Qt or Apple framework types across the core boundary.
5. Keep upstream synchronization working until an explicit project cutover.

## Initial vertical slice

The first proof should be deliberately small:

1. Represent a keyboard shortcut in a framework-neutral form.
2. Select Command+V for macOS targets and Control+V for Windows/Linux targets.
3. Produce deterministic HID reports or protocol packets.
4. Run identical golden vectors against the shared core from Swift and Qt test
   adapters.
5. Leave host event capture and physical transport in the existing frontends.

This demonstrates the full architecture without coupling the first milestone to
video capture, device discovery, packaging, or UI migration.

## Migration phases

- **Phase 0 — Baseline:** Preserve both histories, establish upstream drift
  checks, and document current behavior.
- **Phase 1 — Protocol core:** Keyboard reports, target shortcuts, serial packet
  construction, and shared test vectors.
- **Phase 2 — Hardware workflows:** Chipset strategies and firmware operations
  behind transport interfaces.
- **Phase 3 — Product services:** Shared settings schemas, automation contracts,
  and AI/MCP tool behavior where appropriate.
- **Phase 4 — Cutover decision:** Decide whether both frontends remain, whether
  Qt gains a macOS frontend, and where official ownership resides.

No phase requires deleting an existing frontend before its replacement has
feature parity and physical-hardware verification.
