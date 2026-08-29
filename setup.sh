#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ETC_NIXOS="/etc/nixos"

read -rp "Host: " HOST

Temporary personal key copied into the repo directory.

KEY="$REPO_DIR/keys.txt"

if [[ ! -f "$KEY" ]]; then
echo "Missing personal key: $KEY"
exit 1
fi

echo "Linking /etc/nixos..."

sudo rm -rf "$ETC_NIXOS"
sudo ln -s "$REPO_DIR" "$ETC_NIXOS"

echo "Installing device key..."

sudo install -d -m 700 /var/lib/sops-nix

SOPS_AGE_KEY_FILE="$KEY"
sops decrypt "$REPO_DIR/secrets/device-keys/$HOST.yaml" |
sudo install -m 600 /dev/stdin /var/lib/sops-nix/age-key.txt

echo "Rebuilding..."

sudo nixos-rebuild switch --flake "$ETC_NIXOS#$HOST"

echo "Removing temporary key..."

rm -f "$KEY"

echo "Done."