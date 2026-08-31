{ lib, ... }:

{
  options.my.features.desktop.enable = lib.mkEnableOption "the KDE desktop feature";

  imports = [
    ./kde.nix
    ./gpu-screenrecorder.nix
  ];
}
