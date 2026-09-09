{ pkgs, ... }:

{
  # NixOS maintenance commands consolidated into the `nixctl` CLI tool
  # (defined in ./scripts/nixctl.sh). See `nixctl help` for subcommands.
  home.packages = [
    (pkgs.writeShellScriptBin "nixctl" (builtins.readFile ./scripts/nixctl.sh))
  ];

  programs.fish = {
    # Enable fish servicew
    enable = true;

    # Define fish aliases
    shellAliases = {
    };

    # Define inital command ran when fish shel is started
    interactiveShellInit = ''
      function fish_greeting
          fastfetch
      end
    '';
  };

}
