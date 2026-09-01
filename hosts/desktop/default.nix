{ host, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix
    ./networking

    # inputs.disko.nixosModules.disko
    ../../modules/profiles/workstation.nix
    ../../modules/profiles/shared-networking.nix
    ../../modules/users/hazie.nix
    ../../modules/core/boot/secureboot.nix
    ../../modules/hardware/gpu/nvidia.nix
  ];
  
  sops.defaultSopsFile = host.sopsFile;

  networking.hostName = host.hostName;

  environment.variables.NIXOS_HOST = host.name;
  
  my.secrets.secretsUser = "hazie";
  my.sharedSecrets.enable = true;
  my.profiles.sharedNetworking = {
    wifi.enable = true;
    schoolVpn.enable = true;
  };

  my.profiles.workstation = {
    enable = true;
    desktop = {
      enable = true;
      kde.enable = true;
    };
    gaming.enable = true;
    videoEditing.enable = true;
    tailscale.enable = true;
    protonVpn.enable = true;
  };
}
