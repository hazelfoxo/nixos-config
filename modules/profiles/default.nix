{ ... }:

{
  # The profile layer: every profile and low-level network module is loaded
  # here once, and each one gates its own configuration behind its own
  # options. Hosts import just this file and enable the profiles they need.
  imports = [
    ../networking
    ./workstation.nix
    ./server.nix
    ./shared-networking.nix
    ./ssh-client.nix
    ./desktop
    ./gaming
    ./opencode.nix
    ./tv.nix
    ./video-editing.nix
    ./tailscale.nix
    ./proton-vpn.nix
    ./android-tools.nix
  ];
}
