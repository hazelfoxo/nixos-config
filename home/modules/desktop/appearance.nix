{ lib, osConfig, ... }:

# Configure desktop appearance settings

{

  # Fontconfig configuration for anti-aliasing and hinting
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

  # KDE Plasma System Monitor patch for Applications page icon
  xdg.dataFile."plasma-systemmonitor/applications.page" =
    lib.mkIf osConfig.my.profiles.desktop.kde.enable
      {
        text = ''
          [Face-94920553440704][Appearance]
          chartFace=org.kde.ksysguard.applicationstable
          showTitle=false

          [page]
          Title=Applications
          actionsFace=Face-94920553440704
          icon=applications-all-symbolic
          loadType=
          margin=0
          version=1

          [page][row-0]
          heightMode=balanced
          isTitle=false
          name=row-0

          [page][row-0][column-0]
          name=column-0
          noMargins=true
          showBackground=false

          [page][row-0][column-0][section-0]
          face=Face-94920553440704
          isSeparator=false
          name=section-0
        '';
      };
}
