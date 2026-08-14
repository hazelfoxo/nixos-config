{ ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };

    functions = {
      nix-switch = ''
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
    settings = builtins.fromTOML (
      builtins.readFile ./starship/jetpack.toml
    );
  };
}
