{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.features.desktop.kde.wallpaper = lib.mkOption {
    type = lib.types.path;
    description = "KDE wallpaper used by SDDM and Plasma.";
  };

  config = lib.mkIf config.my.features.desktop.kde.enable {
    services.displayManager.sddm.enable = true;

    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${config.my.features.desktop.kde.wallpaper}
      '')

      pkgs.kdePackages.sddm-kcm
      pkgs.kdePackages.kate
      pkgs.kdePackages.kcalc
      pkgs.haruna
    ];

    programs.partition-manager.enable = true;
  };
}
