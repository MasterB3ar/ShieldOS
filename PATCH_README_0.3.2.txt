ShieldOS 0.3.2 Real UI asset-source fix

This patch fixes the build error:
Path 'assets/identity/shieldos-wallpaper.svg' does not exist in Git repository.

Why it happened:
Nix flakes built from a git repository only see files that are tracked/staged in the git source.
The previous identity module referenced external SVG asset files directly.
If those files were not committed/uploaded exactly in the repo root, Nix could not see them.

What changed:
- modules/identity.nix now generates the ShieldOS wallpaper, icons, color scheme and Plymouth theme inline.
- It no longer depends on ../assets/identity/*.svg during Nix evaluation.
- .github/workflows/build-iso.yml now stages files before building and checks that external asset paths are not used.

Replace these files in your GitHub repo root and rerun Actions.
