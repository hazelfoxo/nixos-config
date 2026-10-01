{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix

    inputs.disko.nixosModules.disko

    ../../modules/networking/github.nix
    ../../modules/networking/shared-connections.nix
    ../../modules/profiles
    ../../modules/users/hazie.nix
  ];

  my.wifi.enable = true;

  my.profiles = {
    workstation = {
      enable = true;
      host = {
        gpu = "nvidia";
        boot = "secureboot";
      };
    };

    homeserver.enable = true;

    university.enable = true;

    desktop.kde = {
      enable = true;
      wallpaper = "Forest-Dark-Winter.jpg";
    };

    gaming = {
      enable = true;
      minecraft.enable = true;
    };
    creative = {
      painting.enable = true;
      video = {
        editor.enable = true;
        tools.enable = true;
      };
    };
    music = {
      enable = true;
      tagging.enable = true;
    };
    dev = {
      enable = true;
      opencode.enable = true;
    };
    protonVpn.enable = true;
  };
}
