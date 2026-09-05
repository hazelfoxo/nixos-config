{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.my.profiles.tv.enable = lib.mkEnableOption "the TV profile";

  config = lib.mkIf config.my.profiles.tv.enable {
    environment.systemPackages = with pkgs; [
      vacuum-tube
    ];
  };
}
