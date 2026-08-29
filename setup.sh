#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$PWD"
ETC_NIXOS="/etc/nixos"
KEY="$REPO_DIR/keys.txt"

read -rp "Host: " HOST

DEVICE_SECRET="$REPO_DIR/secrets/device-keys/$HOST.txt"

[[ -f "$KEY" ]] || {
echo "Error: Personal key not found."
exit 1
}

[[ -f "$DEVICE_SECRET" ]] || {
echo "Error: Device secret for '$HOST' not found."
exit 1
}

export SOPS_AGE_KEY_FILE="$KEY"

echo
echo "==> Linking NixOS configuration..."

sudo rm -rf "$ETC_NIXOS"
sudo ln -s "$REPO_DIR" "$ETC_NIXOS"

echo "==> Installing device key..."

sudo install -d -m 700 /var/lib/sops-nix

sops decrypt "$DEVICE_SECRET" |
sudo install -m 600 /dev/stdin /var/lib/sops-nix/device-key.txt

echo "==> Rebuilding NixOS..."

sudo nixos-rebuild switch --flake "$ETC_NIXOS#$HOST"

echo "==> Removing temporary personal key..."

rm -f "$KEY"

echo
echo "Done."