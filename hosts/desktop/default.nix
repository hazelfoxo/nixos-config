{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix
    ./networking

    ../../modules/profiles
    ../../modules/users/hazie.nix
  ];

  # Bootloader and GPU drivers are selected through the
  # my.profiles.workstation.host options imported above.
  # my.secrets.secretsUser and my.sharedSecrets are set by the desktop
  # profile when it is enabled.

  my.profiles = {
    workstation = {
      enable = true;
      host = {
        gpu = "nvidia";
        boot = "secureboot";
      };
    };

    sshClient.enable = true;

    sharedNetworking = {
      wifi.enable = true;
      schoolVpn.enable = true;
    };

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
  };
}
