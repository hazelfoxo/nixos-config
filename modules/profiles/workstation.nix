{ config, lib, ... }:

# Workstation profile for NixOS hosts

let
  cfg = config.my.profiles.workstation;
in
{
  options.my.profiles.workstation = {
    enable = lib.mkEnableOption "the shared workstation baseline";

    host.gpu = lib.mkOption {
      type = lib.types.enum [
        "none"
        "nvidia"
        "intel"
      ];
      default = "none";
      description = "GPU platform; selects the matching hardware module.";
    };

    host.boot = lib.mkOption {
      type = lib.types.enum [
        "none"
        "systemd-boot"
        "secureboot"
      ];
      default = "none";
      description = "Boot strategy; \"secureboot\" uses Lanzaboote.";
    };
  };

  imports = [
    ../hardware
  ];

  config = lib.mkIf cfg.enable {
    my.core.desktop.enable = true;

    my.hardware.gpu = cfg.host.gpu;

    my.boot.loader = cfg.host.boot;
  };
}
