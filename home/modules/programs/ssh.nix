{ pkgs, ... }:

{
  programs.ssh = {
    # Enable SSH Service
    enable = true;
    # Disable default SSH config to prepare for removal of defaults
    enableDefaultConfig = false;
    settings."*" = {};
  };
  services.ssh-agent.enable = true;
}
