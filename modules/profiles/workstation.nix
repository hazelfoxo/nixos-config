{ config, lib, ... }:

let
  cfg = config.my.profiles.workstation;
in
{
  options.my.profiles.workstation = {
    enable = lib.mkEnableOption "the shared workstation configuration";

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

    desktop.enable = lib.mkEnableOption "desktop applications and services";

    desktop.kde.enable = lib.mkEnableOption "the KDE Plasma desktop";

    desktop.kde.wallpaper = lib.mkOption {
      type = lib.types.path;
      default = ../home/files/wallpapers/Forest-Dark-Winter.jpg;
      description = "Wallpaper used by KDE Plasma and SDDM.";
    };

    desktop.gnome.enable = lib.mkEnableOption "the GNOME desktop";

    gaming.enable = lib.mkEnableOption "gaming applications";

    videoEditing.enable = lib.mkEnableOption "video editing applications";

    tv.enable = lib.mkEnableOption "TV applications";

    tailscale.enable = lib.mkEnableOption "Tailscale";

    protonVpn.enable = lib.mkEnableOption "Proton VPN";
  };

  imports = [
    ./ssh.nix
    ../hardware
    ../features/desktop
    ../networking
    ../features/gaming
    ../features/video-editing
    ../features/tv
  ];

  config = lib.mkIf cfg.enable {
    my.core.desktop.enable = true;

    my.hardware.gpu = cfg.host.gpu;

    my.boot.loader = cfg.host.boot;

    my.features.desktop.enable = cfg.desktop.enable;

    my.features.desktop.kde.enable = cfg.desktop.kde.enable;

    my.features.desktop.kde.wallpaper = cfg.desktop.kde.wallpaper;

    my.features.desktop.gnome.enable = cfg.desktop.gnome.enable;

    my.features.gaming.enable = cfg.gaming.enable;

    my.features.videoEditing.enable = cfg.videoEditing.enable;

    my.features.tv.enable = cfg.tv.enable;

    my.features.tailscale.enable = cfg.tailscale.enable;

    my.features.protonVpn.enable = cfg.protonVpn.enable;
  };
}
