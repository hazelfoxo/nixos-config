{ pkgs, inputs, ... }:

{
  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc

        inputs.nix-vscode-extensions.extensions.${pkgs.system}
          .vscode-marketplace.icrawl.discord-vscode
      ];

      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
      };
    };
  };
}
