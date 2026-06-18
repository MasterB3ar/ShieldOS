ShieldOS 0.3.1 Real UI patch

Replace these files in your repo root:

modules/shield-center.nix
modules/identity.nix
modules/desktop-plasma.nix
apps/shield-center/shield_apps.py
.github/workflows/build-iso.yml
docs/UI_IDENTITY_BUILD.md
hosts/iso/configuration.nix
hosts/installed/configuration.nix

After booting, run:

shield-privacy
shield-store
shield-updates
shield-vault
shield-welcome
shield-apply-identity

If the KDE layout does not change immediately, log out and back in, or run:

shield-apply-identity
