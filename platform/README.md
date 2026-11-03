# Platform adapters

Operating-system and framework integration belongs here. Expected adapters
include device discovery, HID transport, serial transport, video/audio capture,
permissions, keyboard interception, notifications, and packaging hooks.

Adapters should implement narrow interfaces defined by the portable core. They
should not duplicate protocol decisions that can be tested without hardware.
