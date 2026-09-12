{
  config,
  lib,
  pkgs,
  ...
}:

# Minecraft profile configuration for NixOS hosts

lib.mkIf config.my.profiles.gaming.enable {
  environment.systemPackages = with pkgs; [
    prismlauncher
  ];
}
