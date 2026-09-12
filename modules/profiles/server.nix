{ ... }:

{
  imports = [
    ../networking/wireguard-server.nix
    ../networking/server-firewall.nix
    ../services
  ];
}
