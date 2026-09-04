{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.features.gaming.enable {
  environment.systemPackages = with pkgs; [
    prismlauncher
  ];
}
