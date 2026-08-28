{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./VPN

    ../../modules/common.nix
    ../../modules/system/secrets
    
    ../../modules/system/systemd-boot.nix
    ../../modules/hardware/nvidia.nix
  ];
  
  sops.defaultSopsFile = ../../secrets/desktop.yaml;

  networking.hostName = "hazie-pc";

  environment.variables.NIXOS_HOST = "desktop";
}
