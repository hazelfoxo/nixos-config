{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.core.desktop.enable {
  fonts = {
    packages = with pkgs; [
      corefonts
      # nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
    ];

    fontconfig.enable = true;
  };
}
