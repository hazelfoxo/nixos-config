#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$PWD"
ETC_NIXOS="/etc/nixos"
KEY="$REPO_DIR/keys.txt"

read -rp "Host: " HOST

DEVICE_SECRET="$REPO_DIR/secrets/device-keys/$HOST.txt"

[[ -f "$KEY" ]] || {
echo "Missing personal key: $KEY"
exit 1
}

[[ -f "$DEVICE_SECRET" ]] || {
echo "Missing device secret: $DEVICE_SECRET"
exit 1
}

export SOPS_AGE_KEY_FILE="$KEY"

echo "Using key: $SOPS_AGE_KEY_FILE"

sudo rm -rf "$ETC_NIXOS"
sudo ln -s "$REPO_DIR" "$ETC_NIXOS"

sudo install -d -m 700 /var/lib/sops-nix

sops decrypt "$DEVICE_SECRET" |
sudo install -m 600 /dev/stdin /var/lib/sops-nix/key.txt

sudo nixos-rebuild switch --flake "$ETC_NIXOS#$HOST"

rm -f "$KEY"

echo "Done."
