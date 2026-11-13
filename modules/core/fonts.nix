{ ... }:
{
  den.aspects.fonts = {
    nixos =
      { pkgs, ... }:
      {
        fonts = {
          enableDefaultPackages = false;
          fontconfig = {
            enable = true;
            defaultFonts = {
              monospace = [ "JetBrainsMono Nerd Font" ];
              serif = [
                "Inter"
                "Noto Serif CJK SC"
              ];
              sansSerif = [
                "Inter"
                "Noto Sans CJK SC"
              ];
              emoji = [ "Noto Color Emoji" ];
            };
          };
          packages = with pkgs; [
            geist-font
            inter
            nerd-fonts.jetbrains-mono
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji
          ];
        };

        programs.dconf = {
          enable = true;
          profiles.user.databases = [
            {
              settings."org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                font-name = "Inter 9";
                document-font-name = "Inter 9";
                monospace-font-name = "JetBrainsMono Nerd Font 10";
              };
            }
          ];
        };
      };
  };
}
