{ pkgs, ... }:

{
  home.username = "hazie";
  home.homeDirectory = "/home/hazie";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    kdePackages.kate
    discord
    telegram-desktop
    spotify
    pkgs."spotify-adblock"
  ];

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };

    functions = {
      nrs = ''
        sudo nixos-rebuild switch --flake ~/nixos-config#$NIXOS_HOST
        '';
    };

    interactiveShellInit = ''

      function fish_greeting
        fastfetch
      end
    '';
  };

  programs.git = {
    enable = true;
  };
}
