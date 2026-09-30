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
    enable = lib.mkEnableOption "the music profile (Feishin)";

    tagging.enable = lib.mkEnableOption "music tagging tools (Picard, Kid3)";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ pkgs.feishin ];
    })

    (lib.mkIf cfg.tagging.enable {
      environment.systemPackages = with pkgs; [
        picard
        kid3
      ];
    })
  ];
}
