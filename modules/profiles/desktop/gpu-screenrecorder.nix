{ config, lib, ... }:

# GPU Screen Recorder configuration for NixOS hosts

lib.mkIf (config.my.profiles.desktop.kde.enable || config.my.profiles.desktop.gnome.enable) {
  programs.gpu-screen-recorder = {
    enable = true;
    ui.enable = true;
  };
}
