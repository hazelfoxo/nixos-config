{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.profiles.gaming.enable {
  environment.systemPackages = with pkgs; [
    prismlauncher
  ];
}
