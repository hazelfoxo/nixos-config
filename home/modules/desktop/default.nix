{ pkgs, ... }:

{
  imports = [
    ./appearance.nix
    ./wallpapers.nix
    ./kde.nix
  ];
}
