{ config, lib, ... }:

lib.mkIf config.my.profiles.desktop.enable {
  programs.gpu-screen-recorder = {
    enable = true;
    ui.enable = true;
  };
}
