{ ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
    ./VPN
    
    ../../modules/tv/apps.nix
    
    ../../modules/hardware/intel.nix
    ../../modules/system/systemd-boot.nix
  ];

  sops.defaultSopsFile = ../../secrets/laptop.yaml;

  networking.hostName = "hazie-laptop";

  environment.variables.NIXOS_HOST = "laptop";
}
