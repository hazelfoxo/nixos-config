#!/usr/bin/env bash
set -euo pipefail

NIXOS_CONFIG="${NIXOS_CONFIG:-/etc/nixos}"
REPO="${NIXOS_CONFIG%/}"
HOST="${NIXOS_HOST:-$HOSTNAME}"

usage() {
  cat <<'EOF'
Usage: nixctl <command>

Consolidated NixOS maintenance commands.

Commands:
  pull        Pull latest config commits and switch system
              --pull-only: only pull, skip switching
  switch      Rebuild and switch system from the flake
  upgrade     Pull, update flake inputs, rebuild, commit and push flake.lock
  clean       Garbage-collect generations older than 14 days
  clean-all   Garbage-collect all old generations
  help        Show this help

Environment:
  NIXOS_CONFIG  Path to the configuration repo (default: /etc/nixos)
  NIXOS_HOST    Flake attribute to build (default: current hostname)
EOF
}

inhibit() {
  local why="$1"
  shift
  systemd-inhibit --what=idle:sleep --who="nixctl" --why="$why" "$@"
}

cmd_pull() {
  local pull_only=0
  local arg
  for arg in "$@"; do
    case "$arg" in
      --pull-only) pull_only=1 ;;
      *)
        echo "error: unknown option '$arg' for pull" >&2
        return 1
        ;;
    esac
  done

  git -C "$REPO" pull

  if [[ "$pull_only" -eq 0 ]]; then
    cmd_switch
  fi
}

cmd_switch() {
  inhibit "NixOS rebuild in progress" sudo nixos-rebuild switch --flake "$REPO#$HOST"
}

cmd_upgrade() {
  inhibit "NixOS upgrade in progress" "$0" upgrade-internal
}

cmd_upgrade_internal() {
  echo "==> Pulling latest NixOS configuration..."
  git -C "$REPO" pull --ff-only

  echo "==> Updating flake inputs..."
  nix flake update --flake "$REPO"

  echo "==> Rebuilding and switching NixOS..."
  sudo nixos-rebuild switch --flake "$REPO#$HOST"

  if git -C "$REPO" diff --quiet flake.lock; then
    echo "==> flake.lock unchanged. Nothing to commit or push."
  else
    echo "==> Staging updated flake.lock..."
    git -C "$REPO" add flake.lock
    git -C "$REPO" commit -m "Update flake.lock" -- flake.lock
    echo "==> Pushing updated flake.lock..."
    if git -C "$REPO" push; then
      echo "==> Push successful! flake.lock updated."
    else
      echo "==> Push failed!"
    fi
  fi
}

cmd_clean() {
  sudo nix-collect-garbage --delete-older-than 14d
}

cmd_clean_all() {
  sudo nix-collect-garbage -d
}

main() {
  case "${1:-}" in
    pull)                  shift; cmd_pull "$@" ;;
    switch)                cmd_switch ;;
    upgrade)               cmd_upgrade ;;
    upgrade-internal)      cmd_upgrade_internal ;;
    clean)                 cmd_clean ;;
    clean-all)             cmd_clean_all ;;
    help | -h | --help)    usage ;;
    *)                     usage; exit 1 ;;
  esac
}

main "$@"