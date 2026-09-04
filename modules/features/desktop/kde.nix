{ config, lib, pkgs, ... }:

let
  cfg = config.my.features.desktop.kde;
in
{
  options.my.features.desktop.kde.sddmWallpaper = lib.mkOption {
    type = lib.types.nullOr lib.types.path;
    default = null;
    description = "Wallpaper to use for the SDDM login screen.";
  };

  config = lib.mkIf cfg.enable {
    # Enable SDDM
    services.displayManager.sddm = {
      enable = true;

      # Use the Breeze theme
      theme = "breeze";
    };

    # Enable KDE Plasma
    services.desktopManager.plasma6.enable = true;

    # KDE packages
    environment.systemPackages = with pkgs; [
      kdePackages.sddm-kcm
      kdePackages.kate
      kdePackages.kcalc
      haruna
    ];

    # Enable KDE Partition Manager
    programs.partition-manager.enable = true;

    # Configure SDDM wallpaper
    environment.etc."sddm/themes/breeze/theme.conf.user" =
      lib.mkIf (cfg.sddmWallpaper != null) {
        text = ''
          [General]
          background=${cfg.sddmWallpaper}
        '';
      };
  };
}
