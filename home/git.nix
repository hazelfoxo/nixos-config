{ ... }:

{
  programs.git = {
  # Enable git service
    enable = true;

    settings ={
    # Define default git credentials
    user.name = "Hazie";
    user.email = "nicksu2005@gmail.com";
    # Define default git branch name
    init.defaultBranch = "main";
    };
  };
}
