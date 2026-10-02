{
  config,
  lib,
  pkgs,
  ...
}:

# KDE desktop environment configuration for NixOS hosts

{
  config = lib.mkIf config.my.profiles.desktop.kde.enable {
    services.displayManager.sddm.enable = true;

    services.desktopManager.plasma6.enable = true;

    # DDC/CI control of external monitors (brightness/contrast without a KVM).
    # Driven by the DE rather than per host: a Plasma session is what supplies
    # the seat `uaccess` tag that lets the logged-in user talk to /dev/i2c-*
    # without extra group membership, so this is only useful with a DE running.
    #my.hardware.ddc.enable = true;

    environment.systemPackages = [
      (pkgs.writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
        [General]
        background=${config.my.profiles.desktop.kde.wallpaper}
      '')

      pkgs.kdePackages.sddm-kcm
      pkgs.kdePackages.kate
      pkgs.kdePackages.kcalc
      pkgs.haruna
    ];

    programs.partition-manager.enable = true;
  };
}
