{ pkgs, ... }:

{

  # Enable Polkit Service
  security.polkit = {
    enable = true;
    enablePkexecWrapper = true;
  };

  system.stateVersion = "26.05";
}
