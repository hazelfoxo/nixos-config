{ config, lib, ... }:

lib.mkIf config.my.features.desktop.gnome.enable {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Required for persistent GNOME settings configured through DConf.
  programs.dconf.enable = true;

  # Provides credential storage for GNOME applications and network services.
  services.gnome.gnome-keyring.enable = true;
}
