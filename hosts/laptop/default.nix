{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/system/secrets
    ../../modules/hardware/intel.nix
    ../../modules/tv/apps.nix
  ];

  sops.defaultSopsFile = ../../secrets/laptop.yaml;

  sops.secrets.test_secret = {};

  networking.hostName = "hazie-laptop";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.variables.NIXOS_HOST = "laptop";
}
