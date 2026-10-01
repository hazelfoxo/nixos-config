{
  config,
  lib,
  pkgs,
  ...
}:

# Fonts configuration for NixOS hosts

lib.mkIf config.my.core.graphical.enable {
  fonts = {
    packages = with pkgs; [
      corefonts
      # nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
    ];

    fontconfig.enable = true;
  };
}
