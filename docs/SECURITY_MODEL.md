# ShieldOS Security Model

ShieldOS is privacy-first, but it is not magic. The goal is strong default protection without making normal desktop use painful.

## Current protections in 0.2

- No ShieldOS telemetry
- No forced cloud account
- Local user account
- Firewall enabled by default
- OpenSSH disabled by default
- AppArmor enabled
- auditd enabled
- Flatpak support for app permissions
- systemd-resolved DNS privacy preferences
- NetworkManager mDNS/LLMNR disabled by default
- Randomized Wi-Fi scan MAC addresses
- Shorter journal retention
- KeepassXC included for local password storage
- Private Mode command for user-visible privacy state

## What ShieldOS does not yet protect against

- Malicious hardware or firmware
- A fully compromised kernel
- A user manually granting dangerous app permissions
- Browser fingerprinting by itself
- All Windows malware run through Wine/Bottles
- Apps installed outside trusted sources
- Someone with physical access to an unencrypted install

## Recommended future improvements

- Full-disk encryption in the installer
- Graphical Flatpak permission manager shortcut
- Better camera/microphone usage indicators
- Sandboxed browser profiles
- Optional VPN integration
- Secure Boot signing strategy
- Reproducible release checks
