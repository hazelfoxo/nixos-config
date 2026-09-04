{ ... }:

{
  home = {
    username = "hazie";
    homeDirectory = "/home/hazie";
    stateVersion = "26.05";
  };

  # Import Home Manager modules.
  imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ./modules/programs
    ./modules/desktop
    ./modules/shell
  ];
}
