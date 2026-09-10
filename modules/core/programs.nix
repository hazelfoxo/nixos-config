{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.core.desktop.enable {

  environment.systemPackages = with pkgs; [
    firefox
  ];
  
  # Enable Fish
  programs.fish.enable = true;

  programs.localsend.enable = true;
}
