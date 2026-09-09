{ pkgs, vscodeMarketplace, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc # Catpuccin Theme

        vscodeMarketplace.icrawl.discord-vscode # Discord Presence
        vscodeMarketplace.jnoortheen.nix-ide # Nix IDE
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
