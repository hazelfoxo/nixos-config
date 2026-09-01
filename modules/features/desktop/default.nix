{ config, lib, ... }:

{
  options.my.features.desktop = {
    enable = lib.mkEnableOption "shared desktop applications and services";
    kde.enable = lib.mkEnableOption "the KDE Plasma desktop";
    gnome.enable = lib.mkEnableOption "the GNOME desktop";
  };

  imports = [
    ./kde.nix
    ./gnome.nix
    ./gpu-screenrecorder.nix
  ];

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(config.my.features.desktop.kde.enable && config.my.features.desktop.gnome.enable);
          message = "Enable either KDE Plasma or GNOME, not both.";
        }
      ];
    }

    (lib.mkIf (config.my.features.desktop.kde.enable || config.my.features.desktop.gnome.enable) {
      services.flatpak.enable = true;
      xdg.portal.enable = true;
    })
  ];
}
