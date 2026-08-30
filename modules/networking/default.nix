{ ... }:

{
  imports = [
    ./networking.nix
    ./tailscale.nix
    ./wireguard.nix
    ./ssh.nix
    ./proton-vpn.nix
  ];
}
