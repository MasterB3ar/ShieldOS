# ShieldOS Daily Driver Plan

ShieldOS 0.2 moves from a live ISO demo toward a normal desktop OS.

## Design goals

- Easy like Windows/normal Linux
- Private by default, but not so strict that apps break
- KDE Plasma desktop for a familiar UI
- Flatpak/Flathub for normal app-store style installs
- Nix packages for the base system and developer tools
- Steam/Proton and launchers for gaming
- Wine/Bottles through Flatpak for Windows app experiments
- NixOS generations for safe rollback after updates

## App strategy

### System apps

Installed through Nix in the ISO/system configuration.

### Normal desktop apps

Install through Discover from Flathub.

Recommended Flatpaks:

- Discord
- Spotify
- OBS Studio
- Bottles
- OnlyOffice
- GIMP
- Blender
- Kdenlive
- VLC

Run this helper after install if you want common apps quickly:

```bash
shield-install-common-apps
```

### Windows apps

Use Bottles from Flathub first. Wine and Winetricks are included for manual testing.

Windows compatibility is not perfect. Apps with kernel anti-cheat, some Adobe apps and some Microsoft desktop apps may not work well.

## Privacy strategy

Default privacy should be strong but usable:

- No forced online account
- No ShieldOS telemetry
- Firewall enabled
- SSH disabled
- Flatpak permissions
- DNS-over-TLS preference through systemd-resolved
- AppArmor and auditd enabled
- Private Mode command for user-visible privacy state
- KeepassXC included for local password vaults

## Install strategy

The current installer is `shield-install-vm`. It is intentionally VM-focused and non-wiping: it refuses whole disks, does not repartition, and does not format. The user must provide existing EFI/root partitions.

Future versions should add a polished graphical Calamares-style installer with a clear non-destructive partitioning flow.
