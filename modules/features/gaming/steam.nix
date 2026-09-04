{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.features.gaming.enable {
  # Enable Steam
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [
      kdePackages.breeze
    ];
  };
}
