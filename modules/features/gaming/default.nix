{ lib, ... }:

{
  options.my.features.gaming.enable = lib.mkEnableOption "the gaming feature";

  imports = [
    ./minecraft.nix
    ./steam.nix
  ];
}
