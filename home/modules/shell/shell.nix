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
	    echo "==> Pulling latest NixOS configuration..."
	    git -C /etc/nixos pull --ff-only
	    and echo "==> Updating flake inputs..."
            nix flake update --flake /etc/nixos
	    and echo "==> Rebuilding and switching NixOS..."
            sudo nixos-rebuild switch --flake /etc/nixos#$NIXOS_HOST
	    git -C /etc/nixos add flake.lock
	    git -C /etc/nixos commit -m 'Update flake.lock'
	    echo "==> Pushing flake.lock file..."
            if git -C /etc/nixos push
    		echo "==> Push successful! Flake.lock updated!"
	    else
    		echo "==> Push failed! No changes."
	    end
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
