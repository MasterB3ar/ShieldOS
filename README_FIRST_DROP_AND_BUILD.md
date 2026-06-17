# ShieldOS 0.2: drop files, build ISO, use it in a VM

This version is made for the simple GitHub path:

1. Create an empty GitHub repository named `ShieldOS`.
2. Upload the **contents** of this folder to the repository root.
3. Open the repository's **Actions** tab.
4. Run **Build ShieldOS Daily Driver VM ISO**.
5. Download the `ShieldOS-Daily-Driver-VM-ISO` artifact.
6. Boot the `.iso` inside VirtualBox, VMware, UTM, GNOME Boxes or another VM app.
7. Use it live or install it to the VM disk.

## Important when uploading through GitHub website

The repository root must contain these files/folders directly:

```text
.github/workflows/build-iso.yml
flake.nix
hosts/
modules/
apps/
assets/
scripts/
README.md
```

Do **not** upload the whole folder as `ShieldOS/...`, because then GitHub will not find the workflow.

On macOS, press `Command + Shift + .` in Finder to show the hidden `.github` folder before dragging files.

## VM settings

Recommended settings:

- Type: Linux
- Version: Other Linux 64-bit / NixOS 64-bit if available
- Firmware: UEFI enabled if you want to use the installer
- CPU: 2 cores minimum, 4 recommended
- RAM: 4 GB minimum, 8 GB recommended
- Disk: 40 GB or more if installing
- Graphics: 128 MB VRAM or more
- Boot: attach the downloaded `.iso`

## Live login

```text
Username: shield
Password: shield
```

## Safe install to VM partitions

Inside ShieldOS, open Konsole and run:

```bash
lsblk -f
sudo shield-install-vm --root /dev/vda2 --efi /dev/vda1
```

Use the actual partition names shown by `lsblk -f`. The installer refuses whole disks and only accepts partitions. It does **not** wipe, repartition, or format the disk. Use an empty root partition for a clean install.
