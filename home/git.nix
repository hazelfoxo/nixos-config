{ ... }:

{
  programs.git = {
    enable = true;

    settings ={
    user.name = "Hazie";
    user.email = "nicksu2005@gmail.com";
    init.defaultBranch = "main";
    };
  };
}
