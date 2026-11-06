{ inputs, ... }:
let
  thm = inputs.cyberdream.extras;
in
{
  den.aspects.dotfiles.hjem =
    { ... }:
    {
      clobberFiles = true;
      files = {
        ".config/btop/btop.conf".source = ../home/btop/btop.conf;
        ".config/git/config".source = ../home/git/config;
        ".config/k9s/aliases.yaml".source = ../home/k9s/aliases.yaml;
        ".config/k9s/config.yaml".source = ../home/k9s/config.yaml;
        ".config/lazygit/config.yml".source = ../home/lazygit/config.yml;
        ".config/mimeapps.list".source = ../home/mimeapps.list;
        ".local/share/applications/mimeapps.list".source = ../home/mimeapps.list;
        ".config/user-dirs.dirs".source = ../home/user-dirs.dirs;

        # cyberdream themes
        ".config/bat/themes/cyberdream.tmTheme".source = "${thm.textmate}/cyberdream-muted.tmTheme";
        ".config/btop/themes/cyberdream.theme".source = "${thm.btop}/cyberdream-muted.theme";
        ".config/k9s/skins/cyberdream.yaml".source = "${thm.k9s}/cyberdream-muted.yml";
      };
    };
}
