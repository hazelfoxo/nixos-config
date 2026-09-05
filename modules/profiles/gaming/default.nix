{ lib, ... }:

{
  options.my.profiles.gaming.enable = lib.mkEnableOption "the gaming profile";

  imports = [
    ./minecraft.nix
    ./steam.nix
  ];
}
