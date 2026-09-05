{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkIf config.my.profiles.desktop.kde.enable {
    services.displayManager.sddm.enable = true;

    services.desktopManager.plasma6.enable = true;

    environment.systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${config.my.profiles.desktop.kde.wallpaper}
      '')

      pkgs.kdePackages.sddm-kcm
      pkgs.kdePackages.kate
      pkgs.kdePackages.kcalc
      pkgs.haruna
    ];

    programs.partition-manager.enable = true;
  };
}
