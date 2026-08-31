{ host, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking

    ../../modules/profiles/workstation.nix
    ../../modules/users/hazie.nix
    ../../modules/core/boot/systemd-boot.nix
    ../../modules/hardware/gpu/intel.nix
  ];

  sops.defaultSopsFile = host.sopsFile;

  networking.hostName = host.hostName;

  environment.variables.NIXOS_HOST = host.name;

  my.profiles.workstation = {
    enable = true;
    desktop.enable = true;
    gaming.enable = true;
    videoEditing.enable = true;
    tailscale.enable = true;
    protonVpn.enable = true;
  };
}
