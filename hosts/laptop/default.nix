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
        gpu = "intel";
        boot = "systemd-boot";
      };
    };

    homeserver.enable = true;

    university.enable = true;

    desktop = {
      enable = true;
      kde = {
        enable = true;
        wallpaper = ../../home/files/wallpapers/Forest-Dark-Winter.jpg;
      };
    };

    gaming = {
      enable = true;
      minecraft.enable = true;
    };
    creative = {
      painting.enable = true;
      video.enable = true;
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
    virtualisation.waydroid.enable = true;
  };
}
