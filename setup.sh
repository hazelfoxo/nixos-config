#!/usr/bin/env bash
set -euo pipefail

[[ "${IN_NIX_SHELL:-}" == "pure" ]] ||
    exec nix-shell -p sops --run "$0"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/nixos-config"
ETC_LINK="/etc/nix-os"

rm -rf "$CONFIG_DIR"
cp -a "$SCRIPT_DIR" "$CONFIG_DIR"

sudo rm -rf "$ETC_LINK"
sudo ln -s "$CONFIG_DIR" "$ETC_LINK"

read -rp "Host: " HOST
read -rp "Personal age key: " KEY

KEY="${KEY/#\~/$HOME}"

sudo install -d -m 700 /var/lib/sops-nix

SOPS_AGE_KEY_FILE="$KEY" \
    sops decrypt "$CONFIG_DIR/secrets/device-keys/$HOST.yaml" |
    sudo install -m 600 /dev/stdin /var/lib/sops-nix/age-key.txt

sudo nixos-rebuild switch --flake "$CONFIG_DIR#$HOST"

rm -f "$KEY"
