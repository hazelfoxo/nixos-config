{
  config,
  lib,
  pkgs,
  ...
}:

# Minecraft profile configuration for NixOS hosts

{
  config = lib.mkIf (config.my.profiles.gaming.enable && config.my.profiles.gaming.minecraft.enable) {
    environment.systemPackages = with pkgs; [
      prismlauncher
    ];
  };
}
