{ config, lib, ... }:

# Desktop profile configuration for NixOS hosts

let
  cfg = config.my.profiles.desktop;

  # A desktop host is one that runs KDE Plasma or GNOME. The DE choice is the
  # single switch for this profile, so there is no separate profile-level
  # enable that can drift out of sync with it.
  desktopEnabled = cfg.kde.enable || cfg.gnome.enable;
in
{
  options.my.profiles.desktop = {
    kde.enable = lib.mkEnableOption "the KDE Plasma desktop";

    kde.wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "Forest-Dark-Winter.jpg";
      description = "Wallpaper filename in ~/.local/share/wallpapers/ used by KDE Plasma and SDDM.";
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
          assertion = !(cfg.kde.enable && cfg.gnome.enable);
          message = "Enable either KDE Plasma or GNOME, not both.";
        }
      ];
    }

    (lib.mkIf desktopEnabled {
      services.flatpak.enable = true;
      xdg.portal.enable = true;

      # Desktop hosts run the per-user NetworkManager file secret agent and
      # opt into the shared site secrets file used by the networking
      # profiles; headless hosts omit both.
      my.sharedSecrets.enable = true;
    })
  ];
}
