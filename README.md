# ShieldOS 0.2 Daily Driver VM

ShieldOS is an easy, private, app-friendly desktop OS prototype based on NixOS 26.05.

This version is designed for the workflow you wanted:

1. Drop the files into GitHub.
2. Run the GitHub Actions workflow.
3. Download the ISO artifact.
4. Boot it in a VM.
5. Use it like a normal Linux desktop.
6. Optionally install it to existing VM partitions with `shield-install-vm` without wiping the disk.

## What is included

- KDE Plasma 6 desktop with a familiar normal-PC layout
- Firefox, Dolphin files, Konsole, Kate, Discover app store, LibreOffice, VLC
- Flatpak + Flathub setup for normal app-store style app installs
- AppImage support through `appimage-run`
- Wine + Winetricks for Windows app compatibility experiments
- Steam, Proton support, GameMode, MangoHud, Heroic, Lutris, Prism Launcher, Gamescope
- VSCodium, Node.js 22, Python, GitHub CLI, Go, Podman and coding tools
- Firewall enabled, SSH disabled, AppArmor, auditd, DNS privacy settings
- Shield Center, Private Mode and Privacy Report commands
- safe VM install helper: `shield-install-vm`
- VM guest support for QEMU/SPICE, VMware and VirtualBox

## Build on GitHub

Upload the contents of this folder to the root of a GitHub repo, then run:

```text
Actions → Build ShieldOS Daily Driver VM ISO → Run workflow
```

Download the artifact named:

```text
ShieldOS-Daily-Driver-VM-ISO
```

## Build locally

```bash
nix build .#nixosConfigurations.shieldos-iso.config.system.build.isoImage --show-trace -L
```

The ISO appears in:

```text
result/iso/
```

## Live login

```text
Username: shield
Password: shield
```

## Safe install to a VM disk without wiping the disk

`shield-install-vm` is now non-wiping by design. It refuses whole disks and only accepts existing partitions. It does not run `wipefs`, `parted`, or `mkfs`.

Recommended VM layout:

```text
/dev/vda1  EFI partition, FAT32, about 1 GiB
/dev/vda2  Linux root partition, ext4, rest of disk
```

Boot the ISO, open Konsole, then run:

```bash
lsblk -f
sudo shield-install-vm --root /dev/vda2 --efi /dev/vda1
```

This does not erase the disk, repartition it, or format it. It does install ShieldOS files into the selected root partition, so use an empty root partition for a clean install.

After install, reboot and remove the ISO.

## First things to do after install

```bash
passwd
shield-setup-flathub
```

Then open Discover and install apps from Flathub.

## Status

This is still experimental. It is made to be usable in a VM like a normal Linux desktop, but it is not yet a polished production OS.
