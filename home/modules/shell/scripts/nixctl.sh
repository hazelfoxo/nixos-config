#!/usr/bin/env bash
set -euo pipefail

NIXOS_CONFIG="${NIXOS_CONFIG:-/etc/nixos}"
REPO="${NIXOS_CONFIG%/}"
HOST="${NIXOS_HOST:-$HOSTNAME}"
SYSTEM_PROFILE="${NIXCTL_SYSTEM_PROFILE:-/nix/var/nix/profiles/system}"

usage() {
  cat <<'EOF'
Usage: nixctl <command>

Consolidated NixOS maintenance commands.

Commands:
  pull        Rebase-pull latest config commits and switch system
              --pull-only: only pull, skip switching
  switch      Rebuild and switch system from the flake
              [action]   nixos-rebuild action: switch (default), boot, test,
                         build, dry-run, dry-build, dry-activate,
                         list-generations
              Anything else is passed through to nixos-rebuild, e.g.
              nixctl switch --rollback
  upgrade     Pull, update flake inputs, rebuild, commit and push flake.lock
  push [msg]  Stage all changes, commit them and push
              (without a message, an editor is opened)
              --only <path>: stage and commit just this path
  generations List system generations, newest last, current one marked
              --json: raw output from nixos-rebuild
  rollback    Switch to the previous generation
              <gen>: switch to a specific generation id
  clean       Delete unreachable store paths
  clean-all   Delete all old generations, then switch
  shell <pkg…>  Open a nix-shell with the given packages (-p)
  help        Show this help

Environment:
  NIXOS_CONFIG  Path to the configuration repo (default: /etc/nixos)
  NIXOS_HOST    Flake attribute to build (default: current hostname)
  NIXCTL_NET_TIMEOUT  Seconds to wait for the local network (default: 90)
  NIXCTL_NET_REMOTE_TIMEOUT
                      Seconds to additionally wait for the remote (default: 15)
  NIXCTL_PUSH_TRIES   Push attempts before giving up (default: 5)
  NIXCTL_SYSTEM_PROFILE
                      System profile to inspect (default:
                      /nix/var/nix/profiles/system)
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

switch_actions=(switch boot test build dry-run dry-build dry-activate list-generations)
switch_root_actions=(switch boot test)

run_rebuild() {
  local action="$1"
  shift
  local -a rebuild

  if [[ " ${switch_root_actions[*]} " != *" $action "* ]]; then
    rebuild=(nixos-rebuild "$action" --flake "$REPO#$HOST" "$@")
    "${rebuild[@]}"
  else
    rebuild=(sudo nixos-rebuild "$action" --flake "$REPO#$HOST" "$@")
    inhibit "NixOS ${action} in progress" "${rebuild[@]}"
  fi
}

activate_store_path() {
  local action="$1"
  local store_path="$2"
  local -a rebuild=(sudo nixos-rebuild "$action" --store-path "$store_path")

  inhibit "NixOS ${action} in progress" "${rebuild[@]}"
}

cmd_switch() {
  local action=switch
  local -a args=()
  local arg

  for arg in "$@"; do
    if [[ "$arg" != -* && "$action" == switch && " ${switch_actions[*]} " == *" $arg "* ]]; then
      action="$arg"
    else
      args+=("$arg")
    fi
  done

  run_rebuild "$action" "${args[@]}"
}

cmd_reactivate() {
  echo "==> Re-linking the system after garbage collection..."
  cmd_switch
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
  echo "==> Deleting unreachable store paths..."
  sudo nix-collect-garbage
}

cmd_clean_all() {
  echo "==> Garbage-collecting all old generations..."
  sudo nix-collect-garbage -d
  cmd_reactivate
}

cmd_shell() {
  if [[ "$#" -eq 0 ]]; then
    echo "nixctl: error: shell requires at least one package" >&2
    echo "Usage: nixctl shell <pkg...>" >&2
    return 1
  fi
  nix-shell -p "$@"
}

generations_tsv() {
  nixos-rebuild list-generations --json | jq -r '
    def now_local: now | localtime | mktime;

    def age:
      now_local - (strptime("%Y-%m-%d %H:%M:%S") | mktime) as $s
      | if $s < 0 then "just now"
        elif $s < 60 then "\($s)s ago"
        elif $s < 3600 then "\(($s / 60) | floor)m ago"
        elif $s < 86400 then "\(($s / 3600) | floor)h ago"
        elif $s < 2592000 then "\(($s / 86400) | floor)d ago"
        else "\(($s / 2592000) | floor)mo ago"
        end;

    sort_by(.generation)[]
    | [
        (.generation | tostring),
        .date,
        (.date | age),
        .nixosVersion,
        .kernelVersion,
        (if .current then "<- current" else "" end)
      ]
    | @tsv'
}

cmd_generations() {
  local arg
  for arg in "$@"; do
    case "$arg" in
      --json) nixos-rebuild list-generations --json; return 0 ;;
      *)
        echo "nixctl: error: unknown option '$arg' for generations" >&2
        echo "Usage: nixctl generations [--json]" >&2
        return 1
        ;;
    esac
  done

  local rows
  if ! rows="$(generations_tsv)"; then
    echo "nixctl: error: could not list generations" >&2
    return 1
  fi

  if [[ -z "$rows" ]]; then
    echo "No generations found."
    return 0
  fi

  {
    printf 'GEN\tBUILD-DATE\tAGE\tNIXOS VERSION\tKERNEL\t\n'
    printf '%s\n' "$rows"
  } | column -t -s $'\t' | sed 's/[[:space:]]*$//'
}

cmd_rollback() {
  local generation=""
  local arg

  for arg in "$@"; do
    case "$arg" in
      -*)
        echo "nixctl: error: unknown option '$arg' for rollback" >&2
        echo "Usage: nixctl rollback [<gen>]" >&2
        return 1
        ;;
      *)
        if [[ -n "$generation" ]]; then
          echo "nixctl: error: rollback takes at most one generation" >&2
          echo "Usage: nixctl rollback [<gen>]" >&2
          return 1
        fi
        generation="$arg"
        ;;
    esac
  done

  # Plain rollback delegates to nixos-rebuild, which steps the profile back
  # one generation and activates it in a single, well-tested path.
  if [[ -z "$generation" ]]; then
    echo "==> Rolling back to the previous generation..."
    cmd_switch --rollback
    return
  fi

  if ! [[ "$generation" =~ ^[0-9]+$ ]]; then
    echo "nixctl: error: '$generation' is not a generation id" >&2
    return 1
  fi

  local current target
  current="$(generations_tsv | awk -F'\t' '$6 == "<- current" { print $1; exit }')"

  if [[ -z "$current" ]]; then
    echo "nixctl: error: no current generation found" >&2
    return 1
  fi

  if [[ "$generation" == "$current" ]]; then
    echo "nixctl: error: generation ${generation} is already active" >&2
    return 1
  fi

  if ! generations_tsv | awk -F'\t' -v want="$generation" '$1 == want { found = 1 } END { exit !found }'; then
    echo "nixctl: error: no generation ${generation}; run 'nixctl generations'" >&2
    return 1
  fi

  target="$(dirname "$SYSTEM_PROFILE")/$(basename "$SYSTEM_PROFILE")-${generation}-link"

  echo "==> Rolling back to generation ${generation}..."
  activate_store_path switch "$target"
}

main() {
  case "${1:-}" in
    pull)                  shift; cmd_pull "$@" ;;
    switch)                shift; cmd_switch "$@" ;;
    upgrade)               cmd_upgrade ;;
    upgrade-internal)      cmd_upgrade_internal ;;
    push)                  shift; cmd_push "$@" ;;
    generations)           shift; cmd_generations "$@" ;;
    rollback)              shift; cmd_rollback "$@" ;;
    clean)                 cmd_clean ;;
    clean-all)             cmd_clean_all ;;
    shell)                 shift; cmd_shell "$@" ;;
    help | -h | --help)    usage ;;
    *)                     usage; exit 1 ;;
  esac
}

main "$@"