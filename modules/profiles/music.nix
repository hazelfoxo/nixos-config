{
  config,
  lib,
  pkgs,
  ...
}:

# Music profile configuration for NixOS hosts

let
  cfg = config.my.profiles.music;
in
{
  options.my.profiles.music = {
    enable = lib.mkEnableOption "the music profile (Feishin, Spotify)";

    tagging.enable = lib.mkEnableOption "music tagging tools (Picard, Kid3)";

    streaming.enable = lib.mkEnableOption "music streaming (Spotify)";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        feishin
      ];
    })

    (lib.mkIf cfg.spotify.enable {
      environment.systemPackages = with pkgs; [
        spotify-spotx
      ];
    })

    (lib.mkIf cfg.tagging.enable {
      environment.systemPackages = with pkgs; [
        picard
        kid3
      ];
    })
  ];
}
