{ ... }:

{
  imports = [
    ../networking/server-firewall.nix
    ../networking/wifi.nix
    ../networking/wireguard-server.nix
    ../services
  ];
}
