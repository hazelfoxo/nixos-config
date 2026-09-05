{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.profiles.androidTools.enable = lib.mkEnableOption "Android development tools";

  config = lib.mkIf config.my.profiles.androidTools.enable {
    # https://nixos.wiki/wiki/Android
    environment.systemPackages = with pkgs; [
      android-tools
    ];
  };
}
