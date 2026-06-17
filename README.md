# ShieldOS Developer Preview

ShieldOS is a clean, private, easy-to-use desktop OS prototype based on NixOS.

This repository is designed so you can upload it to GitHub, manually run a GitHub Actions workflow, download a bootable ISO artifact, and test ShieldOS in a virtual machine.

## What is included

- NixOS 26.05 live ISO configuration
- KDE Plasma 6 desktop
- Shield Center privacy/control app
- Private Mode command
- Privacy report command
- Firewall enabled by default
- SSH disabled by default
- AppArmor, auditd, Flatpak, Bubblewrap and privacy-oriented NetworkManager defaults
- Developer tools: VSCodium, Node.js, Python, GitHub CLI, Go, Podman and more
- VM guest support for QEMU/SPICE, VMware and VirtualBox

## Fast path

Read this first:

```text
README_FIRST_DROP_AND_BUILD.md
```

## Build locally

```bash
nix build .#nixosConfigurations.shieldos-iso.config.system.build.isoImage --show-trace -L
```

The ISO appears in:

```text
result/iso/
```

## Build on GitHub

The workflow is here:

```text
.github/workflows/build-iso.yml
```

Run it from:

```text
GitHub repo → Actions → Build ShieldOS VM ISO → Run workflow
```

Then download the `ShieldOS-VM-ISO` artifact.

## Live login

```text
Username: shield
Password: shield
```

## Important status

This is a developer preview, not a finished daily-driver OS. Test it in a VM first.
