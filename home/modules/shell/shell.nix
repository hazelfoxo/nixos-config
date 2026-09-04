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
        and nix flake update --flake /etc/nixos

        and echo "==> Rebuilding and switching NixOS..."
        and sudo nixos-rebuild switch --flake /etc/nixos#$NIXOS_HOST

        and begin
            if git -C /etc/nixos diff --quiet flake.lock
                echo "==> flake.lock unchanged. Nothing to commit or push."
            else
                echo "==> Staging updated flake.lock..."
                git -C /etc/nixos add flake.lock

                and git -C /etc/nixos commit -m 'Update flake.lock'

                and begin
                    echo "==> Pushing updated flake.lock..."

                    if git -C /etc/nixos push
                        echo "==> Push successful! flake.lock updated."
                    else
                        echo "==> Push failed!"
                    end
                end
            end
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
