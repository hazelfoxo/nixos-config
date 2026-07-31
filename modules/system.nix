{ pkgs, ... }:

{
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  console.keyMap = "uk";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];


  programs.gpu-screen-recorder.enable = true; # For promptless recording on both CLI and GUI

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    htop
    btop
    fastfetch
    kdePackages.sddm-kcm
    libreoffice
    gpu-screen-recorder-gtk
  ];  

   services.flatpak.enable = true;

   xdg.portal.enable = true;

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
  

  services.xserver.xkb.options = "";

  system.stateVersion = "26.05";
}
