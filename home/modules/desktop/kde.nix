{ kde, inputs, ... }:

{
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
  ];

  programs.plasma = {
    enable = kde.enable;

    workspace.wallpaper = kde.wallpaper;
  };
}