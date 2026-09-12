{ pkgs, vscodeMarketplace, ... }:

# Enable Visual Studio Code and configure its settings

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      # Configure Visual Studio Code extensions
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc # Catpuccin Theme

        vscodeMarketplace.icrawl.discord-vscode # Discord Presence
        vscodeMarketplace.jnoortheen.nix-ide # Nix IDE
      ];

      # Configure Visual Studio Code user settings
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
