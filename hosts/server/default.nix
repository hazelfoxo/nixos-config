{ host, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./access.nix
    ./host-key.nix
  ];

  networking.hostName = host.hostName;
  environment.variables.NIXOS_HOST = host.name;

  # Add this server's hardware-configuration.nix, bootloader, users, and
  # services here when the target machine is ready.

  # Set this to true after following hosts/server/README.md.
  my.server.hostKey.enable = false;
}
