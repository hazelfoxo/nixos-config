{ pkgs, ... }:

# Configure SSH settings and enable SSH agent

{
  programs.ssh = {
    enable = true;
    # Disable default SSH config to prepare for removal of defaults
    enableDefaultConfig = false;
    settings."*" = { };
  };
  services.ssh-agent.enable = true;
}
