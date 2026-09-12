{ ... }:

{
  imports = [
    ./networking.nix
    ./wifi.nix
    ./wireguard.nix
    ./openvpn.nix
    ./ssh.nix
  ];
}
