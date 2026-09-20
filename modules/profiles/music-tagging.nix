{ config, lib, pkgs, ... }:

# Music tagging profile configuration for NixOS hosts

{
  options.my.profiles.musicTagging.enable = lib.mkEnableOption "the music tagging profile";

  config = lib.mkIf config.my.profiles.musicTagging.enable {
    environment.systemPackages = with pkgs; [
      picard
      kid3
    ];
  };
}
