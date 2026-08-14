{ pkgs, ... }:

{
 # Enable experimental NixOS Features e.g. commands and flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Enable fish service
  programs.fish.enable = true;

   # Enable Flatpak Service
  services.flatpak.enable = true;

  # Allow UnFree NixOS Packages
  nixpkgs.config.allowUnfree = true;

  # Install system packages
  environment.systemPackages = with pkgs; [
    git
    htop
    btop
    fastfetch
  ];  

  xdg.portal.enable = true;

  # Install extra fonts and nerd fonts
  fonts = {
    packages = with pkgs; [
      corefonts
      nerd-fonts.caskaydia-mono
      nerd-fonts.caskaydia-cove
    ];

    fontconfig = {
      enable = true;
    };
  };

  # Enable automatic NixOS store garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Enable Polkit Service
  security.polkit = {
    enable = true;
    enablePkexecWrapper = true;
  };

  system.stateVersion = "26.05";
}
