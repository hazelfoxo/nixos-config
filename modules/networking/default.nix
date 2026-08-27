{ ... }:

{
  imports = [
    ./networking.nix
    ./tailscale.nix
    ./localsend.nix
    ./proton-vpn.nix
  ];
}
