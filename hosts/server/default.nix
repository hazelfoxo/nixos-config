{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./access.nix
    ./networking

    ../../modules/server
    ../../modules/profiles
  ];

  # Headless server template: a plain systemd-boot like the workstations, but
  # without the desktop boot cosmetics. The workstation profile is what sets
  # my.boot.loader for workstations; here it is set directly.
  my.boot.loader = "systemd-boot";

  my.server.firewall.enable = true;

  # Enable after the SOPS device key and encrypted SSH host key are restored.
  my.server.hostKey.enable = false;
}
