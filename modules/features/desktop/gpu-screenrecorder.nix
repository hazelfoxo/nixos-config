{ config, lib, ... }:

lib.mkIf config.my.features.desktop.enable {
  programs.gpu-screen-recorder = {
    enable = true;
    ui.enable = true;
  };
}
