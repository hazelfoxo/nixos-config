{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    # ./disko.nix
    ./networking

    inputs.disko.nixosModules.disko

    ../../modules/profiles/workstation.nix
    ../../modules/profiles/shared-networking.nix
    ../../modules/users/hazie.nix
  ];

  # Bootloader and GPU drivers are selected through the
  # my.profiles.workstation.host options imported above.
  my.secrets.secretsUser = "hazie";
  my.sharedSecrets.enable = true;

  my.profiles.sharedNetworking = {
    wifi.enable = true;
    schoolVpn.enable = true;
  };

  my.profiles.workstation = {
    enable = true;

    host = {
      gpu = "intel";
      boot = "systemd-boot";
    };

    desktop = {
      enable = true;
      kde.enable = true;
      kde.wallpaper = ../../home/files/wallpapers/Forest-Dark-Winter.jpg;
    };

    gaming.enable = true;
    videoEditing.enable = true;
    tailscale.enable = true;
    protonVpn.enable = true;
  };
}
