# Contributing to ShieldOS

ShieldOS is currently an experimental developer preview. Contributions should keep the same goals:

- Easy to use
- Private by default
- Clean UI
- Safe updates and rollback
- Good gaming and developer support

## Local development

```bash
nix flake check
nix build .#nixosConfigurations.shieldos-iso.config.system.build.isoImage
```

## Pull request rules

Before opening a pull request:

1. Keep changes focused.
2. Explain what changed and why.
3. Do not add telemetry or tracking.
4. Do not add cloud login requirements.
5. Test the ISO build when the change affects system modules.

## Security changes

For privacy/security-related changes, explain:

- What threat the change protects against
- What it does not protect against
- Any compatibility trade-offs
