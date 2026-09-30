{ lib, ... }:

# Gaming profile configuration for NixOS hosts

{
  options.my.profiles.gaming = {
    enable = lib.mkEnableOption "the gaming profile";

    minecraft.enable = lib.mkEnableOption "Minecraft (Prism Launcher)";
  };

  imports = [
    ./minecraft.nix
    ./steam.nix
  ];
}
