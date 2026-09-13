{ ... }:

{
  home = {
    username = "hazie";
    homeDirectory = "/home/hazie";
    stateVersion = "26.05";
  };

  # Import Home Manager modules.
  imports = [
    ./modules/programs
    ./modules/desktop
    ./modules/shell
    ./modules/directories.nix
  ];
}
