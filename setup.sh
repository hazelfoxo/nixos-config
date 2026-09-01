#!/usr/bin/env bash

set -euo pipefail

if ! command -v sops >/dev/null 2>&1; then
    exec nix-shell -p sops --run "bash '$0'"
fi

BOOTSTRAP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="/mnt"
FINAL_REPO="$TARGET_ROOT/etc/nixos"
KEY="$BOOTSTRAP_DIR/keys.txt"

REMOTE_URL="git@github.com:hazelfoxo/nixos-config.git"

read -rp "Host: " HOST

echo
echo "==> Optional Disko setup"
echo "WARNING: Disko will destroy, format, and mount every disk defined for '$HOST'."
read -rp "Type 'ERASE $HOST' to run Disko, or press Enter to skip: " DISKO_CONFIRMATION

if [[ "$DISKO_CONFIRMATION" == "ERASE $HOST" ]]; then
    echo "==> Running Disko for '$HOST'..."
    sudo nix --extra-experimental-features "nix-command flakes" \
        run github:nix-community/disko -- \
        --mode destroy,format,mount \
        --flake "$BOOTSTRAP_DIR#$HOST"
else
    echo "==> Skipping Disko."
fi

DEVICE_SECRET="$BOOTSTRAP_DIR/secrets/device-keys/$HOST.txt"

[[ -f "$KEY" ]] || {
    echo "Error: Personal key not found."
    exit 1
}

[[ -f "$DEVICE_SECRET" ]] || {
    echo "Error: Device secret for '$HOST' not found."
    exit 1
}

mountpoint -q "$TARGET_ROOT" || {
    echo "Error: $TARGET_ROOT is not mounted. Run Disko or mount the target system first."
    exit 1
}

[[ ! -e "$FINAL_REPO" ]] || {
    echo "Error: Canonical configuration path already exists: $FINAL_REPO"
    exit 1
}

echo
echo "==> Installing device key in the target system..."

sudo install -d -m 700 "$TARGET_ROOT/var/lib/sops-nix"

export SOPS_AGE_KEY_FILE="$KEY"

sops decrypt "$DEVICE_SECRET" |
    sudo install -m 600 /dev/stdin "$TARGET_ROOT/var/lib/sops-nix/device-key.txt"

echo "==> Cloning canonical configuration repository into the target system..."

sudo install -d -m 755 -o "$(id -u)" -g "$(id -g)" "$TARGET_ROOT/etc"
git clone "$REMOTE_URL" "$FINAL_REPO"
sudo chown -R root:root "$TARGET_ROOT/etc"

echo "==> Installing NixOS from the canonical Git repository..."

sudo nixos-install \
    --flake "$FINAL_REPO#$HOST" \
    --no-root-passwd \
    --extra-experimental-features "nix-command flakes"

echo
echo "==> Installation complete. Reboot into the installed system."
