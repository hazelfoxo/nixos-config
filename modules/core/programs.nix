{
  config,
  lib,
  pkgs,
  ...
}:

# System programs for NixOS hosts

lib.mkIf config.my.core.desktop.enable {

  environment.systemPackages = with pkgs; [
    firefox
  ];

  # Enable Fish
  programs.fish.enable = true;

  programs.localsend.enable = true;
}
