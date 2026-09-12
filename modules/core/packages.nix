{ pkgs, ... }:

# System packages configuration for NixOS hosts

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
