{ config, lib, ... }:

let
  cfg = config.my.profiles.workstation;
in
{
  options.my.profiles.workstation = {
    enable = lib.mkEnableOption "the shared workstation configuration";

    desktop.enable = lib.mkEnableOption "desktop applications and services";

    desktop.kde = {
      enable = lib.mkEnableOption "the KDE Plasma desktop";

      sddmWallpaper = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Wallpaper to use for the SDDM login screen.";
      };
    };

    desktop.gnome.enable = lib.mkEnableOption "the GNOME desktop";

    gaming.enable = lib.mkEnableOption "gaming applications";
    videoEditing.enable = lib.mkEnableOption "video editing applications";
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
  ];

  config = lib.mkIf cfg.enable {
    my.features.desktop.enable = cfg.desktop.enable;

    my.features.desktop.kde.enable = cfg.desktop.kde.enable;
    my.features.desktop.kde.sddmWallpaper = cfg.desktop.kde.sddmWallpaper;

    my.features.desktop.gnome.enable = cfg.desktop.gnome.enable;

    my.features.gaming.enable = cfg.gaming.enable;
    my.features.videoEditing.enable = cfg.videoEditing.enable;
    my.features.tailscale.enable = cfg.tailscale.enable;
    my.features.protonVpn.enable = cfg.protonVpn.enable;
  };
}
