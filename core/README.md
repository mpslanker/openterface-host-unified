# Portable core

This directory will contain framework-neutral application and hardware-domain
logic shared by every host frontend.

Initial extraction candidates are:

1. Target operating-system shortcut selection.
2. HID keyboard report and serial packet construction.
3. Keyboard-layout data and normalization.
4. CH9329 and CH32V208 protocol state machines.
5. WCH firmware parsing and flashing orchestration.

The core must not depend on SwiftUI, AppKit, Qt Widgets, AVFoundation, Windows
APIs, Linux APIs, or a particular video backend. Those dependencies belong in
`platform` or an application frontend.
