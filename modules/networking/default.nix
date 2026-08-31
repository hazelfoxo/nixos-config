{ ... }:

{
  imports = [
    ./networking.nix
    ./tailscale.nix
    ./wireguard.nix
    ./wifi.nix
    ./ssh.nix
    ./proton-vpn.nix
  ];
}
