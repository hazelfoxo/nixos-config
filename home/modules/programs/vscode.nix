{ pkgs, vscodeMarketplace, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc

        vscodeMarketplace.icrawl.discord-vscode
        vscodeMarketplace.jnoortheen.nix-ide
      ];

      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "chat.titleBar.openInAgentsWindow.enabled" = false;
        "chat.titleBar.signIn.enabled" = false;
        "editor.fontFamily" = "'CaskaydiaCove Nerd Font', monospace";
        "git.confirmSync" = false;
        "git.enableSmartCommit" = true;
        "git.autofetch" = true;
      };
    };
  };
}
