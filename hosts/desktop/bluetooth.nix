{ pkgs, ... }:

{
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  services.displayManager.sddm.enable = true;

  environment.systemPackages = with pkgs; [
    kdePackages.sddm-kcm
  ];
}
