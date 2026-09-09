{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.core.desktop.enable {

  # Enable Firefox
  programs.firefox = {
    enable = true;

    policies.Preferences = {
      "middlemouse.paste" = false;
    };

  # Enable Fish
  programs.fish.enable = true;

  programs.localsend.enable = true;
}
