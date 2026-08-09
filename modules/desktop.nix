{ pkgs, ... }:

{

  services.displayManager.sddm.enable = true;

  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
    options = "";
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  services.printing.enable = false;

  programs.firefox.enable = true;

  programs.steam.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];

}
