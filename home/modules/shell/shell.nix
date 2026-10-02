{ pkgs, ... }:

# Configure fish shell

let
  scriptsDir = ../../files/scripts;

  writeScripts = dir:
    map
      (name:
        pkgs.writeShellScriptBin
          (builtins.replaceStrings [ ".sh" ] [ "" ] name)
          (builtins.readFile "${dir}/${name}")
      )
      (builtins.filter
        (name: builtins.match ".*\\.sh" name != null)
        (builtins.attrNames (builtins.readDir dir)));
in

{
  home.packages = writeScripts scriptsDir;

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
