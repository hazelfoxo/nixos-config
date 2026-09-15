{
  config,
  lib,
  pkgs,
  ...
}:

# Development profile configuration for NixOS hosts

let
  cfg = config.my.profiles.dev;
in
{
  options.my.profiles.dev = {
    enable = lib.mkEnableOption "the development profile";

    opencode.enable = lib.mkEnableOption "opencode";
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = with pkgs; [
        android-tools
      ];
    })

    (lib.mkIf cfg.opencode.enable {
      environment.systemPackages = with pkgs; [
        opencode
      ];
    })
  ];
}
