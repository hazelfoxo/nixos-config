{ lib, ... }:

# Gaming profile configuration for NixOS hosts

{
  options.my.profiles.gaming.enable = lib.mkEnableOption "the gaming profile";

  imports = [
    ./minecraft.nix
    ./steam.nix
  ];
}
