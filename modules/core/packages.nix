{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    htop
    btop
    fastfetch
    usbutils
    pciutils
  ];
}
