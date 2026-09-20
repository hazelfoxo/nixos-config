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
    ./dev.nix
    ./gaming
    ./tv.nix
    ./video-editing.nix
    ./creative.nix
    ./tailscale.nix
    ./proton-vpn.nix
    ./virtualisation.nix
    ./music-tagging.nix
  ];
}
