#!/usr/bin/env bash

set -euo pipefail

echo "[1/8] Checking for sops..."

[[ "${IN_NIX_SHELL:-}" == "pure" ]] ||
exec nix-shell -p sops --run "$0"

echo "[2/8] Finding script directory..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

CONFIG_DIR="$HOME/nixos-config"
ETC_LINK="/etc/nix-os"

echo "[3/8] Copying config to $CONFIG_DIR..."

rm -rf "$CONFIG_DIR"
cp -a "$SCRIPT_DIR" "$CONFIG_DIR"

echo "[4/8] Creating $ETC_LINK symlink..."

sudo rm -rf "$ETC_LINK"
sudo ln -s "$CONFIG_DIR" "$ETC_LINK"

read -rp "Host: " HOST
read -rp "Personal age key: " KEY

KEY="${KEY/#~/$HOME}"

echo "[5/8] Creating sops key directory..."

sudo install -d -m 700 /var/lib/sops-nix

echo "[6/8] Decrypting device key..."

SOPS_AGE_KEY_FILE="$KEY" 
sops decrypt "$CONFIG_DIR/secrets/device-keys/$HOST.yaml" |
sudo install -m 600 /dev/stdin /var/lib/sops-nix/age-key.txt

echo "[7/8] Rebuilding NixOS..."

sudo nixos-rebuild switch --flake "$CONFIG_DIR#$HOST"

echo "[8/8] Removing temporary key..."

rm -f "$KEY"

echo "Done."
