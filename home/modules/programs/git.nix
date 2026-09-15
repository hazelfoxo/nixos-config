{ pkgs, ... }:

# Configure git settings and credentials

{
  programs.git = {
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

    includes = [
      {
        # Define git credentials for Uni Gitlab Repositories
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
