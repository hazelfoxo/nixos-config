{ pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  services.blueman.enable = false;

  services.displayManager.sddm.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];
}
