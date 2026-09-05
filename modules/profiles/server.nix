{ ... }:

{
  # Server profile. The foundational networking (Wi-Fi) and WireGuard client
  # definitions come from the shared profiles layer; this only pulls in the
  # server-specific pieces that no other profile uses.
  imports = [
    ../networking/wireguard-server.nix
    ../networking/server-firewall.nix
    ../services
  ];
}
