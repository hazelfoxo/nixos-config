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
  pull        Rebase-pull latest config commits and switch system
              --pull-only: only pull, skip switching
  switch      Rebuild and switch system from the flake
  upgrade     Pull, update flake inputs, rebuild, commit and push flake.lock
  push [msg]  Stage all changes, commit them and push
              (without a message, an editor is opened)
              --only <path>: stage and commit just this path
  clean       Garbage-collect generations older than 14 days
  clean-all   Garbage-collect all old generations
  shell <pkg…>  Open a nix-shell with the given packages (-p)
  help        Show this help

Environment:
  NIXOS_CONFIG  Path to the configuration repo (default: /etc/nixos)
  NIXOS_HOST    Flake attribute to build (default: current hostname)
  NIXCTL_NET_TIMEOUT  Seconds to wait for the local network (default: 90)
  NIXCTL_NET_REMOTE_TIMEOUT
                      Seconds to additionally wait for the remote (default: 15)
  NIXCTL_PUSH_TRIES   Push attempts before giving up (default: 5)
EOF
}

inhibit() {
  local why="$1"
  shift
  systemd-inhibit --what=idle:sleep --who="nixctl" --why="$why" "$@"
}

net_timeout="${NIXCTL_NET_TIMEOUT:-90}"
net_remote_timeout="${NIXCTL_NET_REMOTE_TIMEOUT:-15}"
push_tries="${NIXCTL_PUSH_TRIES:-5}"

remote_host() {
  local url
  url="$(git -C "$REPO" remote get-url --push origin 2>/dev/null || true)"
  [[ -n "$url" ]] || return 1
  url="${url#*://}"
  url="${url#*@}"
  printf '%s\n' "${url%%[:/]*}"
}

net_open() {
  local connect="exec 3<>/dev/tcp/$1/$2"
  if command -v timeout >/dev/null 2>&1; then
    timeout 2 bash -c "$connect" >/dev/null 2>&1
  else
    (eval "$connect") >/dev/null 2>&1
  fi
}

net_local_ready() {
  ip route show default 2>/dev/null | grep -q .
}

net_reachable() {
  net_open "$1" 22 || net_open "$1" 443
}

wait_until() {
  local check="$1" timeout="$2" what="$3"
  local deadline
  shift 3
  deadline=$(( SECONDS + timeout ))
  while (( SECONDS < deadline )); do
    if "$check" "$@"; then
      return 0
    fi
    sleep 1
  done
  echo "nixctl: warning: ${what} not ready after ${timeout}s; continuing" >&2
  return 0
}

wait_for_network() {
  local what="$1" local_timeout="${2:-$net_timeout}"
  local host
  if ! host="$(remote_host)"; then
    return 0
  fi
  wait_until net_local_ready "$local_timeout" "network ${what}"
  wait_until net_reachable "$net_remote_timeout" "${host} ${what}" "$host"
}

git_push_retry() {
  local attempt
  for (( attempt = 1; attempt <= push_tries; attempt++ )); do
    if git -C "$REPO" push; then
      return 0
    fi
    if (( attempt < push_tries )); then
      echo "==> Push attempt ${attempt}/${push_tries} failed, retrying..."
      wait_for_network "before push retry" 30
    fi
  done
  return 1
}

cmd_pull() {
  local pull_only=0
  local arg
  for arg in "$@"; do
    case "$arg" in
      --pull-only) pull_only=1 ;;
      *)
        echo "error: unknown option '$arg' for pull" >&2
        echo "Usage: nixctl pull [--pull-only]" >&2
        return 1
        ;;
    esac
  done

  wait_for_network "before pull"
  git -C "$REPO" pull --rebase --autostash

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
  cmd_pull --pull-only

  echo "==> Updating flake inputs..."
  nix flake update --flake "$REPO"

  echo "==> Rebuilding and switching NixOS..."
  sudo nixos-rebuild switch --flake "$REPO#$HOST"

  if git -C "$REPO" diff --quiet -- flake.lock; then
    echo "==> flake.lock unchanged. Nothing to commit or push."
  elif cmd_push --only flake.lock "Update flake.lock"; then
    echo "==> flake.lock updated."
  else
    echo "==> flake.lock is committed locally; run 'nixctl push' later."
  fi
}

cmd_push() {
  local -a msg=() add_args=(add) only=()
  local message
  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      --only) only+=("$2"); shift 2 ;;
      *) msg+=("$1"); shift ;;
    esac
  done
  message="${msg[*]}"

  if [[ "${#only[@]}" -gt 0 ]]; then
    echo "==> Staging ${only[*]}..."
    add_args+=("${only[@]}")
  else
    echo "==> Staging all changes..."
    add_args+=(-A)
  fi
  git -C "$REPO" "${add_args[@]}"

  if git -C "$REPO" diff --cached --quiet; then
    echo "==> Nothing to commit."
  elif [[ -n "$message" ]]; then
    echo "==> Committing: $message"
    git -C "$REPO" commit -m "$message" -- "${only[@]}"
  elif [[ -t 0 && -t 1 ]]; then
    echo "==> Opening editor for commit message..."
    git -C "$REPO" commit
  else
    echo "nixctl: error: commit message required when not running interactively" >&2
    echo "Usage: nixctl push [--only <path>] <message>" >&2
    return 1
  fi

  wait_for_network "before push"
  echo "==> Pushing to remote..."
  if git_push_retry; then
    echo "==> Push successful!"
  else
    echo "nixctl: error: push failed after ${push_tries} attempts" >&2
    return 1
  fi
}

cmd_clean() {
  sudo nix-collect-garbage --delete-older-than 14d
}

cmd_clean_all() {
  sudo nix-collect-garbage -d
}

cmd_shell() {
  if [[ "$#" -eq 0 ]]; then
    echo "nixctl: error: shell requires at least one package" >&2
    echo "Usage: nixctl shell <pkg...>" >&2
    return 1
  fi
  nix-shell -p "$@"
}

main() {
  case "${1:-}" in
    pull)                  shift; cmd_pull "$@" ;;
    switch)                cmd_switch ;;
    upgrade)               cmd_upgrade ;;
    upgrade-internal)      cmd_upgrade_internal ;;
    push)                  shift; cmd_push "$@" ;;
    clean)                 cmd_clean ;;
    clean-all)             cmd_clean_all ;;
    shell)                 shift; cmd_shell "$@" ;;
    help | -h | --help)    usage ;;
    *)                     usage; exit 1 ;;
  esac
}

main "$@"