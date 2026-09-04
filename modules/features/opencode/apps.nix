{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.features.opencode.enable {
  environment.systemPackages = with pkgs; [
    opencode
  ];
}
