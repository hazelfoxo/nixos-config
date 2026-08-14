{ pkgs, ... }:

{
  programs.ssh = {
    # Enable SSH Service
    enable = true;
    # Disable default SSH config to prepare for removal of defaults
    enableDefaultConfig = false;
    # Automatically use github ssh keys for repo access
    extraConfig = ''
      Host github.com
        IdentityFile ~/.ssh/github
        IdentitiesOnly yes
    '';
  };
}
