{ lib, ... }:

{
  options.my.features.videoEditing.enable = lib.mkEnableOption "the video editing feature";

  imports = [
    ./apps.nix
  ];
}
