{ pkgs, ... }:

{
  gtk = {
    enable = true;

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

    font = {
      name = "Noto Sans";
      size = 10;
    };
  };

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
