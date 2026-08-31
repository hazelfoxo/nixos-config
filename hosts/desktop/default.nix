{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./VPN
    
    ../../modules/system/secureboot.nix
    ../../modules/hardware/nvidia.nix
  ];
  
  sops.defaultSopsFile = ../../secrets/hosts/desktop.yaml;

  networking.hostName = "hazie-pc";

  environment.variables.NIXOS_HOST = "desktop";
}
