#!/usr/bin/env bash

set -euo pipefail

BOOTSTRAP_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

TARGET_ROOT="/mnt"
FINAL_REPO="$TARGET_ROOT/etc/nixos"

KEY="$BOOTSTRAP_DIR/keys.txt"
BOOTSTRAP_SECRET="$BOOTSTRAP_DIR/secrets/bootstrap.txt"

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

[[ -f "$BOOTSTRAP_SECRET" ]] || {
    echo "Error: Bootstrap SSH key not found at $BOOTSTRAP_SECRET."
    exit 1
}

DEVICE_SECRET="$BOOTSTRAP_DIR/secrets/device-keys/$HOST.txt"

[[ -f "$DEVICE_SECRET" ]] || {
    echo "Error: Device secret for '$HOST' not found at $DEVICE_SECRET."
    exit 1
}

# Temporary location for the decrypted bootstrap SSH key.
BOOTSTRAP_SSH_KEY="$(mktemp)"
chmod 600 "$BOOTSTRAP_SSH_KEY"

# Remove the decrypted key when the script exits, regardless of success/failure.
trap 'rm -f "$BOOTSTRAP_SSH_KEY"' EXIT

export SOPS_AGE_KEY_FILE="$KEY"

echo "==> Decrypting bootstrap GitHub SSH key..."

sops decrypt "$BOOTSTRAP_SECRET" > "$BOOTSTRAP_SSH_KEY"

echo "==> Verifying GitHub SSH access..."

if ! GIT_SSH_COMMAND="ssh \
    -i $BOOTSTRAP_SSH_KEY \
    -o IdentitiesOnly=yes \
    -o BatchMode=yes \
    -o ConnectTimeout=10 \
    -o StrictHostKeyChecking=yes" \
    git ls-remote "$REMOTE_URL" HEAD >/dev/null 2>&1; then

    echo "Error: Bootstrap SSH key cannot access the GitHub repository."
    exit 1
fi

echo "==> GitHub SSH access verified."

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

sops decrypt "$DEVICE_SECRET" |
    sudo install -m 600 /dev/stdin \
        "$TARGET_ROOT/var/lib/sops-nix/device-key.txt"

echo "==> Cloning canonical configuration repository into the target system..."

sudo install -d -m 755 \
    -o "$(id -u)" \
    -g "$(id -g)" \
    "$TARGET_ROOT/etc"

GIT_SSH_COMMAND="ssh \
    -i $BOOTSTRAP_SSH_KEY \
    -o IdentitiesOnly=yes \
    -o StrictHostKeyChecking=yes" \
    git clone "$REMOTE_URL" "$FINAL_REPO"

sudo chown -R root:root "$TARGET_ROOT/etc"

echo "==> Installing NixOS from the canonical Git repository..."

sudo nixos-install \
    --flake "$FINAL_REPO#$HOST" \
    --no-root-passwd \
    --extra-experimental-features "nix-command flakes"

echo
echo "==> Installation complete. Reboot into the installed system."