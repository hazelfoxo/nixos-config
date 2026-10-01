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
      type = lib.types.path;
      default = ../../home/files/wallpapers/Forest-Dark-Winter.jpg;
      description = ''
        Wallpaper used by SDDM. Resolved to a nix store path, which is what
        the display manager needs since it runs before any user session.
      '';
    };

    kde.wallpaperName = lib.mkOption {
      type = lib.types.str;
      default = builtins.baseNameOf (toString cfg.kde.wallpaper);
      description = ''
        Name of the wallpaper inside ~/.local/share/wallpapers/, used by KDE
        Plasma and the screen locker. Defaults to the file name of
        `kde.wallpaper`, which home-manager copies to that directory, so the
        two stay in sync.
      '';
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
