# GitHub setup

This repository uses GitHub Actions to build ShieldOS into a bootable ISO.

Workflow file:

```text
.github/workflows/build-iso.yml
```

Manual workflow name:

```text
Build ShieldOS Daily Driver VM ISO
```

Build command used by the workflow:

```bash
nix build .#nixosConfigurations.shieldos-iso.config.system.build.isoImage --show-trace -L
```

Output artifact:

```text
ShieldOS-Daily-Driver-VM-ISO
```

## Common problems

### The Actions tab does not show the workflow

Make sure `.github/workflows/build-iso.yml` is at the repository root, not inside another folder.

### GitHub still builds old files

Open `modules/privacy.nix` in GitHub and confirm there is no `tor-browser-bundle-bin` and no dynamic package lookup helper.

### VM will not boot after installing

For the current `shield-install-vm` installer, enable UEFI firmware in the VM settings before installing.
