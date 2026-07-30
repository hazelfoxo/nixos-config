{
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;

  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  services.printing.enable = false;

  programs.firefox.enable = true;

  programs.steam.enable = true;
}
