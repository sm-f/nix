{ theme, ... }:
{
  den.aspects.dotfiles.hjem =
    { ... }:
    {
      files = {
        ".config/btop/btop.conf".source = ../dotfiles/btop/btop.conf;
        ".config/k9s/aliases.yaml".source = ../dotfiles/k9s/aliases.yaml;
        ".config/k9s/config.yaml".source = ../dotfiles/k9s/config.yaml;
        ".config/mimeapps.list".source = ../dotfiles/mimeapps.list;
        ".config/user-dirs.dirs".source = ../dotfiles/user-dirs.dirs;

        # cyberdream themes
        ".config/bat/themes/cyberdream.tmTheme".source = theme.textmate;
        ".config/btop/themes/cyberdream.theme".source = theme.btop;
        ".config/k9s/skins/cyberdream.yaml".source = theme.k9s;
      };
    };
}
