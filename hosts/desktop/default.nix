{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/gpu-screenrecorder.nix
    ../../modules/locale.nix
    ../../modules/nvidia.nix
    ../../modules/programs.nix
    ../../modules/bluetooth.nix
    ../../modules/audio.nix
    ../../modules/desktop.nix
    ../../modules/networking.nix
    ../../modules/system.nix
    ../../modules/users.nix
    ../../modules/localsend.nix
  ];

  networking.hostName = "hazie-pc";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.variables.NIXOS_HOST = "desktop";
}
