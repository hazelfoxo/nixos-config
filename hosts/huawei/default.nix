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

  my.hardware.sil6250.enable = true;
  my.hardware.battery.enable = true;

  my.wifi.enable = true;

  my.profiles = {

    workstation = {
      enable = true;
      host = {
        gpu = "intel";
        boot = "systemd-boot";
      };
    };

    desktop = {
      enable = true;
      kde = {
        enable = true;
        wallpaper = ../../home/files/wallpapers/Forest-Dark-Winter.jpg;
      };
    };

    dev = {
      enable = true;
      opencode.enable = true;
    };

    homeserver.enable = true;

    school.enable = true;

    # gaming.enable = true;
    # videoEditing.enable = true;
    # creative.painting.enable = true;
    # musicTagging.enable = true;

    # tailscale is enabled by the homeserver profile
    # protonVpn.enable = true;
    # virtualisation.enable = false;
  };
}
