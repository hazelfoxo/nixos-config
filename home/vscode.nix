{ pkgs, inputs, ... }:

let
  vscode-marketplace =
    inputs.nix-vscode-extensions.extensions.${pkgs.stdenv.hostPlatform.system}
      .vscode-marketplace;
in
{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc

        vscode-marketplace.icrawl.discord-vscode
        vscode-marketplace.jnoortheen.nix-ide
      ];

      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "chat.titleBar.openInAgentsWindow.enabled" = false;
          "chat.titleBar.signIn.enabled" = false;
      };
    };
  };
}
