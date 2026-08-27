{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./VPN

    ../../modules/common.nix
    ../../modules/system/secrets
    
    ../../modules/hardware/nvidia.nix
  ];
  
  sops.defaultSopsFile = ../../secrets/desktop.yaml;

  networking.hostName = "hazie-pc";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.variables.NIXOS_HOST = "desktop";
}
