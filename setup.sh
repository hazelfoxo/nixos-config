#!/usr/bin/env bash

set -euo pipefail

if ! command -v sops >/dev/null 2>&1; then
    exec nix-shell -p sops --run "bash '$0'"
fi

BOOTSTRAP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

FINAL_REPO="$HOME/nixos-config"

ETC_NIXOS="/etc/nixos"
KEY="$BOOTSTRAP_DIR/keys.txt"

REMOTE_URL="git@github.com:YOUR_USERNAME/YOUR_NIXOS_CONFIG.git"

read -rp "Host: " HOST

DEVICE_SECRET="$BOOTSTRAP_DIR/secrets/device-keys/$HOST.txt"

[[ -f "$KEY" ]] || {
    echo "Error: Personal key not found."
    exit 1
}

[[ -f "$DEVICE_SECRET" ]] || {
    echo "Error: Device secret for '$HOST' not found."
    exit 1
}

[[ ! -e "$FINAL_REPO" ]] || {
    echo "Error: Final repository already exists: $FINAL_REPO"
    exit 1
}

export SOPS_AGE_KEY_FILE="$KEY"

echo
echo "==> Installing device key..."

sudo install -d -m 700 /var/lib/sops-nix

sops decrypt "$DEVICE_SECRET" |
    sudo install -m 600 /dev/stdin /var/lib/sops-nix/device-key.txt

echo "==> Building bootstrap NixOS generation..."

sudo nixos-rebuild switch --flake "$BOOTSTRAP_DIR#$HOST"

echo
echo "==> Bootstrap generation activated."
echo "==> Cloning canonical configuration repository..."

git clone "$REMOTE_URL" "$FINAL_REPO"

echo "==> Copying local decryption key to cloned repository..."

install -m 600 "$KEY" "$FINAL_REPO/keys.txt"

KEY="$FINAL_REPO/keys.txt"
export SOPS_AGE_KEY_FILE="$KEY"

echo "==> Linking canonical repository to /etc/nixos..."

sudo rm -rf "$ETC_NIXOS"
sudo ln -s "$FINAL_REPO" "$ETC_NIXOS"

echo "==> Rebuilding from canonical Git repository..."

sudo nixos-rebuild switch --flake "$FINAL_REPO#$HOST"

echo
echo "Done."
