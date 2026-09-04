{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix
    ./networking

    ../../modules/profiles/workstation.nix
    ../../modules/profiles/shared-networking.nix
    ../../modules/users/hazie.nix
  ];

  # Bootloader and GPU drivers are selected through the
  # my.profiles.workstation.host options imported above.
  # my.secrets.secretsUser and my.sharedSecrets are set by the workstation
  # profile when its desktop is enabled.

  my.profiles.sharedNetworking = {
    wifi.enable = true;
    schoolVpn.enable = true;
  };

  my.profiles.workstation = {
    enable = true;

    host = {
      gpu = "nvidia";
      boot = "secureboot";
    };

    desktop = {
      enable = true;
      kde.enable = true;
      kde.wallpaper = ../../home/files/wallpapers/Forest-Dark-Winter.jpg;
    };

    gaming.enable = true;
    videoEditing.enable = true;
    opencode.enable = true;
    tailscale.enable = true;
    protonVpn.enable = true;
  };
}
