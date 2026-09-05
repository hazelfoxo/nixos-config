{
  config,
  lib,
  pkgs,
  ...
}:

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
