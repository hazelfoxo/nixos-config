{ ... }:

{
  imports = [
    ./networking.nix
    ./tailscale.nix
    ./localsend.nix
    ./wireguard.nix
    ./ssh.nix
    ./proton-vpn.nix
  ];
}
