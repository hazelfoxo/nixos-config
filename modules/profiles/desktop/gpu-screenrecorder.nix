{ config, lib, ... }:

# GPU Screen Recorder configuration for NixOS hosts

lib.mkIf config.my.profiles.desktop.enable {
  programs.gpu-screen-recorder = {
    enable = true;
    ui.enable = true;
  };
}
