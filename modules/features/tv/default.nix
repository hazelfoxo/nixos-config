{ lib, ... }:

{
  options.my.features.tv.enable = lib.mkEnableOption "the TV feature";

  imports = [
    ./apps.nix
  ];
}
