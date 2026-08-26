#!/usr/bin/env bash
set -euo pipefail

# Bootstrap git if it isn't currently available
if ! command -v git >/dev/null 2>&1; then
    echo "==> Git not found, entering nix-shell with git..."
    exec nix-shell -p git --run "$0"
fi

REPO="git@github.com:hazelfoxo/nixos-config.git"
TMP_DIR="/tmp/nixos-config"
HOME_DIR="$HOME/nixos-config"
SSH_KEY="$HOME/.ssh/github"

echo "==> NixOS configuration bootstrap"
echo

read -r -p "Enter the NixOS host to use (e.g. desktop): " FLAKE_HOST

if [ -z "$FLAKE_HOST" ]; then
    echo "ERROR: Host cannot be empty."
    exit 1
fi

echo
echo "==> Using flake host: $FLAKE_HOST"
echo

# Generate GitHub SSH key
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$SSH_KEY" ]; then
    echo "==> Generating GitHub SSH key..."
    ssh-keygen -t ed25519 -f "$SSH_KEY" -C "github" -N ""
else
    echo "==> GitHub SSH key already exists, skipping generation."
fi

chmod 600 "$SSH_KEY"
chmod 644 "$SSH_KEY.pub"

echo
echo "============================================================"
echo "Add the following SSH key to GitHub:"
echo
cat "$SSH_KEY.pub"
echo
echo "GitHub → Settings → SSH and GPG keys → New SSH key"
echo "============================================================"
echo

read -r -p "Press Enter once you've added the key to GitHub..."

echo
echo "==> Testing GitHub SSH access..."

if ! ssh \
    -i "$SSH_KEY" \
    -o IdentitiesOnly=yes \
    -o StrictHostKeyChecking=accept-new \
    -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    echo
    echo "ERROR: GitHub SSH authentication failed."
    echo "Make sure you added the public key above to your GitHub account."
    exit 1
fi

echo "==> GitHub SSH authentication successful!"

echo
echo "==> Cloning NixOS configuration..."
rm -rf "$TMP_DIR"

GIT_SSH_COMMAND="ssh -i $SSH_KEY -o IdentitiesOnly=yes" \
    git clone "$REPO" "$TMP_DIR"

echo "==> Copying configuration to $HOME..."
rm -rf "$HOME_DIR"
cp -a "$TMP_DIR" "$HOME_DIR"

echo "==> Linking /etc/nixos..."
sudo rm -rf /etc/nixos
sudo ln -s "$HOME_DIR" /etc/nixos

echo "==> Rebuilding NixOS..."
sudo nixos-rebuild switch --flake "/etc/nixos#$FLAKE_HOST"

echo
echo "==> Done!"
