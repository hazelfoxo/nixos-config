{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.my.features.desktop.gnome.enable {
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Required for persistent GNOME settings configured through DConf.
  programs.dconf.enable = true;

  # Provides credential storage for GNOME applications and network services.
  services.gnome.gnome-keyring.enable = true;

  # Remove some default GNOME apps
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
  ];

}
