{
  config,
  lib,
  pkgs,
  ...
}:

# Steam Configuration for NixOS hosts

lib.mkIf config.my.profiles.gaming.enable {
  # Enable Steam
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      kdePackages.breeze
    ];
  };
}
