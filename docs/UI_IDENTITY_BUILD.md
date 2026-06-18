# ShieldOS 0.3.1 Real UI Build

This build fixes the earlier partial identity layer. The ShieldOS apps are packaged as real separate launchers and the KDE session applies ShieldOS visual defaults automatically.

## Commands

```bash
shield-center
shield-privacy
shield-store
shield-updates
shield-vault
shield-welcome
shield-apply-identity
```

## What changed

- Separate real launchers for Shield Center, Privacy, Store, Updates, Vault, Welcome and Browser.
- Desktop entries are built with `makeDesktopItem` and use absolute Nix store paths.
- Autostart applies ShieldOS wallpaper, dark/cyan color scheme, Papirus dark icons and a custom Plasma panel layout.
- The no-wipe installer remains unchanged in principle: it installs only to explicitly selected existing root/EFI partitions.

## Reality note

This is still KDE/Plasma underneath, but it now applies a ShieldOS identity layer at login so it should no longer feel like untouched stock NixOS.
