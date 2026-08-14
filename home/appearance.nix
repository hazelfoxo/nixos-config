{ pkgs, ... }:

{

# KDE Appearance Config
  gtk = {
  # Enable GTK Theming
    enable = true;

    # Set all themes to breeze
    theme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-gtk;
    };

    iconTheme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-icons;
    };

    cursorTheme = {
      name = "Breeze";
      package = pkgs.kdePackages.breeze-icons;
    };
    # Set default system font to Noto
    font = {
      name = "Noto Sans";
      size = 10;
    };
  };

  # Force default KDE text hinting and anti-aliasing settings
  xdg.configFile."fontconfig/fonts.conf".text = ''
    <?xml version='1.0'?>
    <fontconfig>
      <match target="pattern">
        <edit mode="assign" name="rgba">
          <const>rgb</const>
        </edit>
      </match>

      <match target="pattern">
        <edit mode="assign" name="hinting">
          <bool>true</bool>
        </edit>
      </match>

      <match target="pattern">
        <edit mode="assign" name="hintstyle">
          <const>hintslight</const>
        </edit>
      </match>

      <dir>~/.local/share/fonts</dir>

      <match target="pattern">
        <edit mode="assign" name="antialias">
          <bool>true</bool>
        </edit>
      </match>
    </fontconfig>
  '';
}
