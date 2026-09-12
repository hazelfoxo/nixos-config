{
  config,
  lib,
  pkgs,
  ...
}:

# Opencode profile configuration for NixOS hosts

{
  options.my.profiles.opencode.enable = lib.mkEnableOption "opencode";

  config = lib.mkIf config.my.profiles.opencode.enable {
    environment.systemPackages = with pkgs; [
      opencode
    ];
  };
}
