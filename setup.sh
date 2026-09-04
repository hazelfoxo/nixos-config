#!/usr/bin/env bash

set -euo pipefail

BOOTSTRAP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_ROOT="/mnt"
FINAL_REPO="$TARGET_ROOT/etc/nixos"
KEY="$BOOTSTRAP_DIR/keys.txt"

REMOTE_URL="git@github.com:hazelfoxo/nixos-config.git"

KNOWN_HOSTS="desktop laptop server"

if ! command -v sops >/dev/null 2>&1; then
    exec nix --extra-experimental-features "nix-command flakes" \
        develop "$BOOTSTRAP_DIR" --command bash "$0"
fi

read -rp "Host: " HOST

[[ " $KNOWN_HOSTS " == *" $HOST "* ]] || {
    echo "Error: Unknown host '$HOST'. Valid hosts: $KNOWN_HOSTS."
    exit 1
}

echo "==> Verifying keys..."

[[ -f "$KEY" ]] || {
    echo "Error: Personal key not found at $KEY."
    exit 1
}

DEVICE_SECRET="$BOOTSTRAP_DIR/secrets/device-keys/$HOST.txt"

[[ -f "$DEVICE_SECRET" ]] || {
    echo "Error: Device secret for '$HOST' not found at $DEVICE_SECRET."
    exit 1
}

echo "==> Verifying GitHub SSH access..."

if ! ssh -o BatchMode=yes -o ConnectTimeout=10 -T git@github.com 2>&1 |
    grep -q "successfully authenticated"; then
    echo "Error: GitHub SSH authentication failed. Load an SSH key into ssh-agent or fix ~/.ssh."
    exit 1
fi

echo
echo "==> Optional Disko setup"
echo "WARNING: Disko will destroy, format, and mount every disk defined for '$HOST'."
read -rp "Type 'ERASE $HOST' to run Disko, or press Enter to skip: " DISKO_CONFIRMATION

if [[ "$DISKO_CONFIRMATION" == "ERASE $HOST" ]]; then
    echo "==> Running Disko for '$HOST'..."
    sudo nix --extra-experimental-features "nix-command flakes" \
        run "$BOOTSTRAP_DIR#disko" -- \
        --mode destroy,format,mount \
        --flake "$BOOTSTRAP_DIR#$HOST"
else
    echo "==> Skipping Disko."
fi

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