#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

git init >/dev/null 2>&1 || true
git add .

nix build .#nixosConfigurations.shieldos-iso.config.system.build.isoImage

echo
echo "ShieldOS ISO build complete."
echo "Look in: result/iso/"
