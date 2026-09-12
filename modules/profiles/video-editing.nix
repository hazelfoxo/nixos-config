{
  config,
  lib,
  pkgs,
  ...
}:

# Video editing profile configuration for NixOS hosts

{
  options.my.profiles.videoEditing.enable = lib.mkEnableOption "the video editing profile";

  config = lib.mkIf config.my.profiles.videoEditing.enable {
    environment.systemPackages = with pkgs; [
      kdePackages.kdenlive
      ffmpeg
      handbrake
    ];
  };
}
