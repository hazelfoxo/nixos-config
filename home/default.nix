{ pkgs, ... }:

{
  home.username = "hazie";
  home.homeDirectory = "/home/hazie";
  home.stateVersion = "26.05";

  home.file.".face.icon".source = ./assets/face.png;

   imports = [
    ./apps.nix
    ./kde.nix
    ./shell.nix
    ./git.nix
    ./appearance.nix
  ];

}
