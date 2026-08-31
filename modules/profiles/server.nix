{ ... }:

{
  imports = [
    ../core/locale.nix
    ../core/nix.nix
    ../core/security.nix
    ../networking/server-firewall.nix
    ../networking/wifi.nix
    ../networking/wireguard-server.nix
    ../services
  ];

  # Keep this profile independent from the desktop-oriented core module.
  system.stateVersion = "26.05";
}
