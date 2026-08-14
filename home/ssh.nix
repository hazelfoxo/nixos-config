{ pkgs, ... }:

{
  programs.ssh = {
  enable = true;

  extraConfig = ‘’
    # Test if github.com works with ssh for cloning
    Host github.com
    IdentityFile ~/.ssh/github
    ‘’;
  };

};
