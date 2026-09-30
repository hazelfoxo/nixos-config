{ ... }:

{
  imports = [
    ../networking
    ./workstation.nix
    ./homeserver.nix
    ./university.nix
    ./desktop
    ./dev.nix
    ./gaming
    ./tv.nix
    ./creative.nix
    ./tailscale.nix
    ./proton-vpn.nix
    ./virtualisation.nix
    ./music-tagging.nix
  ];
}
