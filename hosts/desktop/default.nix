{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./vpn
    ../../modules/profiles/workstation.nix
    
    ../../modules/core/boot/secureboot.nix
    ../../modules/hardware/gpu/nvidia.nix
  ];
  
  sops.defaultSopsFile = ../../secrets/hosts/desktop.yaml;

  networking.hostName = "hazie-pc";

  environment.variables.NIXOS_HOST = "desktop";
}
