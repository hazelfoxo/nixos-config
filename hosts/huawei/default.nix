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
    
    github.enable = true;
    
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

    sharedNetworking = {
      wifi.enable = true;
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
    
    # tailscale.enable = true;
    # protonVpn.enable = true;
    # virtualisation.enable = false;
  };
}
