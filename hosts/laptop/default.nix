{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/hardware/intel.nix
    ../../modules/media/bigscreen.nix
  ];

  networking.hostName = "hazie-laptop";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.variables.NIXOS_HOST = "laptop";
}
