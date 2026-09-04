{ osConfig, ... }:

{
  programs.plasma = {
    enable = osConfig.my.features.desktop.kde.enable;

    workspace.wallpaper = osConfig.my.features.desktop.kde.wallpaper;
  };
}
