{ config, lib, pkgs, ... }:

let
  breeze-sddm = pkgs.kdePackages.sddm-kcm;
in

{
  options.my.features.desktop.kde.wallpaper = lib.mkOption {
    type = lib.types.path;
    default = /etc/nixos/home/files/wallpapers/Forest-Dark-Winter.jpg;
    description = "Wallpaper used by the Breeze SDDM theme.";
  };

  config = lib.mkIf config.my.features.desktop.kde.enable {

    # Enable SDDM login manager service
    services.displayManager.sddm.enable = true;

    # Enable KDE Plasma
    services.desktopManager.plasma6.enable = true;

    # Install KDE Specific Packages
    environment.systemPackages = with pkgs; [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${config.my.features.desktop.kde.sddmWallpaper}
      '')

      kdePackages.sddm-kcm
      kdePackages.kate
      kdePackages.kcalc
      haruna
    ];

    # Enable KDE Partition Manager
    programs.partition-manager.enable = true;
  };
}