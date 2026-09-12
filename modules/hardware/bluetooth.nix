{ pkgs, ... }:

# Enable bluetooth service for NixOS hosts

{
  # Enable bluetooth service
  hardware.bluetooth.enable = true;
}
