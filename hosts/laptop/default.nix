{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
    ./networking

    inputs.disko.nixosModules.disko

    ../../modules/profiles
    ../../modules/users/hazie.nix
  ];

  my.profiles = {
    workstation = {
      enable = true;
      host = {
        gpu = "intel";
        boot = "systemd-boot";
      };
    };

    github.enable = true;

    sharedNetworking = {
      wifi.enable = true;
    };

    homeserver.enable = true;

    school.enable = true;

    desktop = {
      enable = true;
      kde = {
        enable = true;
        wallpaper = ../../home/files/wallpapers/Forest-Dark-Winter.jpg;
      };
    };

    gaming.enable = true;
    videoEditing.enable = true;
    opencode.enable = true;
    tailscale.enable = true;
    protonVpn.enable = true;
    androidTools.enable = true;
  };
}
