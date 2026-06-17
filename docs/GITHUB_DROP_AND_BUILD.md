# GitHub drop-and-build guide

## 1. Create the repo

Create an empty GitHub repository named `ShieldOS`.

Do not add a README, license or `.gitignore` on GitHub if you are uploading this package, because those files are already included.

## 2. Upload the files

Upload the contents of this folder to the repository root.

The root should contain:

```text
.github/workflows/build-iso.yml
flake.nix
hosts/
modules/
apps/
assets/
docs/
scripts/
README.md
```

On macOS, press `Command + Shift + .` in Finder so the hidden `.github` folder is visible.

## 3. Run the workflow

Go to:

```text
Actions → Build ShieldOS Daily Driver VM ISO → Run workflow
```

## 4. Download the ISO

When the workflow finishes, open the run and download:

```text
ShieldOS-Daily-Driver-VM-ISO
```

Unzip the artifact and boot the `.iso` in your VM.

## 5. Install inside the VM

Boot the ISO, open Konsole and run:

```bash
lsblk -dpno NAME,SIZE,MODEL,TYPE
sudo shield-install-vm --root /dev/vda2 --efi /dev/vda1
```

Use the disk name shown by `lsblk`. In VirtualBox it may be `/dev/sda`.
