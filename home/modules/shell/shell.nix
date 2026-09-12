{ pkgs, ... }:

# Configure fish shell

{
  home.packages = [
    (pkgs.writeShellScriptBin "nixctl" (builtins.readFile ./scripts/nixctl.sh))
  ];

  programs.fish = {
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
