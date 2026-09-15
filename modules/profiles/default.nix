{ ... }:

{
  imports = [
    ../networking
    ./workstation.nix
    ./server.nix
    ./shared-networking.nix
    ./homeserver.nix
    ./school.nix
    ./github.nix
    ./desktop
    ./gaming
    ./opencode.nix
    ./tv.nix
    ./video-editing.nix
    ./tailscale.nix
    ./proton-vpn.nix
    ./android-tools.nix
    ./virtualisation.nix
  ];
}
