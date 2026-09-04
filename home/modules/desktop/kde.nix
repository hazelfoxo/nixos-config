{ osConfig, inputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma = {
    enable = osConfig.my.features.desktop.kde.enable;

    workspace.wallpaper = osConfig.my.features.desktop.kde.wallpaper;
  };
}
