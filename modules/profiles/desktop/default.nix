{ config, lib, ... }:

# Desktop profile configuration for NixOS hosts

{
  options.my.profiles.desktop = {
    enable = lib.mkEnableOption "the desktop profile";

    kde.enable = lib.mkEnableOption "the KDE Plasma desktop";

    kde.wallpaper = lib.mkOption {
      type = lib.types.path;
      default = ../../home/files/wallpapers/Forest-Dark-Winter.jpg;
      description = "Wallpaper used by KDE Plasma and SDDM.";
    };

    gnome.enable = lib.mkEnableOption "the GNOME desktop";
  };

  imports = [
    ./kde.nix
    ./gnome.nix
    ./gpu-screenrecorder.nix
  ];

  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !(config.my.profiles.desktop.kde.enable && config.my.profiles.desktop.gnome.enable);
          message = "Enable either KDE Plasma or GNOME, not both.";
        }
      ];
    }

    (lib.mkIf (config.my.profiles.desktop.kde.enable || config.my.profiles.desktop.gnome.enable) {
      services.flatpak.enable = true;
      xdg.portal.enable = true;
    })

    # Desktop workstations run the per-user NetworkManager file secret agent
    # and opt into the shared site secrets file used by the networking
    # profiles; headless hosts omit both.
    (lib.mkIf config.my.profiles.desktop.enable {
      my.secrets.secretsUser = "hazie";

      my.sharedSecrets.enable = true;
    })
  ];
}
