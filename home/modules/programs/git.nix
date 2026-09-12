{ pkgs, ... }:

{
  programs.git = {
    # Enable git service
    enable = true;

    settings = {
      # Define default git credentials
      user = {
        name = "Hazie";
        email = "nicksu2005@gmail.com";
      };
      # Define default git branch name
      init.defaultBranch = "main";
    };

    # Use a different identity for Chester University repos.
    # Home-manager appends this after `settings`, so the included
    # identity takes precedence over the personal defaults above.
    includes = [
      {
        condition = "hasconfig:remote.*.url:git@git.chester.network:*/**";
        contents = {
          user = {
            name = "Nick Su";
            email = "2326991@chester.ac.uk";
          };
        };
      }
    ];
  };
}