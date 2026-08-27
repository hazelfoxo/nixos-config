{ ... }:

{
  programs.fish = {
    # Enable fish servicew
    enable = true;

    # Define fish aliases
    shellAliases = {
    };

    # Define fish functions
    functions = {

    # NiXOS Commonly Used Commands

        # Pull latest repo commits
        nix-pull = ''
            git -C ~/nixos-config pull
        '';

        # Rebuild system from flake
        nix-switch = ''
            sudo nixos-rebuild switch --flake ~/nixos-config#$NIXOS_HOST
        '';

        # Upgrade package lock and then packages for system
        nix-upgrade = ''
            sudo nix flake update --flake /etc/nixos
            sudo nixos-rebuild switch --flake ~/nixos-config#$NIXOS_HOST
        '';

        # Deletes generations older than 14d days and garbage-collects old stores
        nix-clean = ''
            sudo nix-collect-garbage --delete-older-than 14d
        '';

        # Deletes all old generations and garbage-collects old stores
        nix-clean-all = ''
            sudo nix-collect-garbage -d
        '';
    };

        # Define inital command ran when fish shel is started
        interactiveShellInit = ''
            function fish_greeting
                fastfetch
            end
        '';
  };

}
