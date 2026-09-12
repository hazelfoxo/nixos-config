{ ... }:

{
  imports = [
    ../networking
    ./workstation.nix
    ./server.nix
    ./shared-networking.nix
    ./homeserver.nix
    ./school.nix
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
