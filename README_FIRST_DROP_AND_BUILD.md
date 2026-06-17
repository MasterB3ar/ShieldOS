# ShieldOS: drop files, build ISO, boot in a VM

This version is made for the simple GitHub path:

1. Create an empty GitHub repository named `ShieldOS`.
2. Upload the contents of this folder to the repository root.
3. Open the repository's **Actions** tab.
4. Run **Build ShieldOS VM ISO**.
5. Download the `ShieldOS-VM-ISO` artifact.
6. Use the `.iso` inside VirtualBox, VMware, UTM, GNOME Boxes, or another VM app.

## Very important when uploading through the GitHub website

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

Do not upload the whole folder as `ShieldOS/...`, because then GitHub will not find the workflow.

On macOS, press `Command + Shift + .` in Finder to show the hidden `.github` folder before dragging files.

## VM settings

Recommended settings:

- Type: Linux
- Version: Other Linux 64-bit / NixOS 64-bit if available
- CPU: 2 cores or more
- RAM: 4 GB minimum, 8 GB recommended
- Disk: 25 GB or more if you install it later
- Graphics: 128 MB VRAM or more
- Boot: attach the downloaded `.iso`

## Live login

```text
Username: shield
Password: shield
```
