{ pkgs, ... }:

{
  home.username = "hazie";
  home.homeDirectory = "/home/hazie";
  home.file.".face.icon".source = ./assets/face.png;

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    kdePackages.kate
    haruna
    discord
    telegram-desktop
    spotify
    localsend
    kdePackages.kweather
    pkgs."spotify-adblock"
    vacuum-tube
  ];

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };

    functions = {
      nix-switch= ''
        sudo nixos-rebuild switch --flake ~/nixos-config#$NIXOS_HOST
        '';

        nix-upgrade = ''
        sudo nix flake update /etc/nixos
        sudo nixos-rebuild switch --flake ~/nixos-config#$NIXOS_HOST
        '';

        nix-clean = ''
        sudo nix-collect-garbage -d
        '';
    };

    interactiveShellInit = ''

      function fish_greeting
        fastfetch
      end
    '';
  };

  home.file.".config/fastfetch".source = ./fastfetch;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ./starship/jetpack.toml);
  };

  xdg.configFile."fontconfig/fonts.conf".text = ''
<?xml version='1.0'?>
<fontconfig>
 <match target="pattern">
  <edit mode="assign" name="rgba">
   <const>rgb</const>
  </edit>
 </match>
 <match target="pattern">
  <edit mode="assign" name="hinting">
   <bool>true</bool>
  </edit>
 </match>
 <match target="pattern">
  <edit mode="assign" name="hintstyle">
   <const>hintslight</const>
  </edit>
 </match>
 <dir>~/.local/share/fonts</dir>
 <match target="pattern">
  <edit mode="assign" name="antialias">
   <bool>true</bool>
  </edit>
 </match>
</fontconfig>
  '';

  programs.git = {
    enable = true;
  };

  gtk = {
  enable = true;

  theme = {
    name = "Breeze";
    package = pkgs.kdePackages.breeze-gtk;
  };

  iconTheme = {
    name = "Breeze";
    package = pkgs.kdePackages.breeze-icons;
  };

  cursorTheme = {
    name = "Breeze";
    package = pkgs.kdePackages.breeze-icons;
  };

  font = {
    name = "Noto Sans";
    size = 10;
  };
};

}
