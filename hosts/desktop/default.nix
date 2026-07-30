{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nvidia.nix

    ../../modules/bluetooth.nix
    ../../modules/audio.nix
    ../../modules/desktop.nix
    ../../modules/networking.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/localsend.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.variables.NIXOS_HOST = "desktop";

}
