{ lib, ... }:

{
  options.my.features.opencode.enable = lib.mkEnableOption "the opencode feature";

  imports = [
    ./apps.nix
  ];
}
