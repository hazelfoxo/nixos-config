{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./access.nix
    ./host-key.nix
    ./networking

    ../../modules/profiles/server.nix
  ];

  # Headless server template: a plain systemd-boot like the workstations, but
  # without the desktop boot cosmetics. Override for Secure Boot if needed.
  my.boot.loader = "systemd-boot";

  my.server.firewall.enable = true;

  # Enable after the SOPS device key and encrypted SSH host key are restored.
  my.server.hostKey.enable = false;
}
