{ ... }:

{
  programs.git = {
    enable = true;

    userName = "Hazie";
    userEmail = "...";

    extraConfig = {
        init.defaultBranch = "main";
    };
  };
}
