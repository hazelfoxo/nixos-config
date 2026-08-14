{ pkgs, ... }:

{
  # Define default user settings
  home.username = "hazie";
  # Define default user directory
  home.homeDirectory = "/home/hazie";
  # Define NixOS Version for home manager
  home.stateVersion = "26.05";

  # Copy profile picture from repo to system
  home.file.".face.icon".source = ./assets/face.png;

  # Import Home-manager modules
   imports = [
    ./apps.nix
    ./kde.nix
    ./shell.nix
    ./git.nix
    ./ssh.nix
    ./appearance.nix
  ];

}
