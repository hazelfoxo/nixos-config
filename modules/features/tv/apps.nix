{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.features.tv.enable {
  environment.systemPackages = with pkgs; [
    vacuum-tube
  ];
}
