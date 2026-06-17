# ShieldOS Security Model

ShieldOS is designed around one rule:

> Privacy should be the default, not an advanced setting.

## Current protections in 0.1

### Local-first design

The live system does not require an online account.

### Firewall

The firewall is enabled by default with no manually opened inbound ports.

### SSH disabled

OpenSSH server is disabled by default.

### AppArmor

AppArmor is enabled for mandatory access control support.

### Audit logging

auditd is enabled so security-sensitive activity can be logged and inspected.

### DNS and local network privacy

systemd-resolved is configured with DNS-over-TLS support and LLMNR/mDNS disabled.
NetworkManager is configured to randomize Wi-Fi scan MAC addresses.

### Flatpak support

Flatpak is enabled so apps can be installed with sandboxed permissions.

## Not solved yet

ShieldOS 0.1 does **not** yet provide:

- Verified boot
- Full per-app native Linux permission prompts
- Perfect anti-tracking
- A production installer
- Secure default disk encryption for installed systems
- Signed ISO release verification
- Production-grade telemetry blocking across every app

## Production goals

For a real release, ShieldOS should add:

- Secure Boot support
- Encrypted disk install by default
- Btrfs or ZFS snapshots
- Automatic rollback
- Signed updates
- Reproducible release build pipeline
- Per-app network controls
- Real-time camera/microphone indicators
