{ inputs, utils, ... }:
let
  thm = inputs.cyberdream.extras;
in
{
  den.aspects.dotfiles.hjem =
    { pkgs, ... }:
    let
      mkSym = utils.mkSymlink pkgs;
    in
    {
      clobberFiles = true;
      files = {
        ".config/bat/config".source = ../home/bat/config;
        ".config/btop/btop.conf".source = ../home/btop/btop.conf;
        ".config/git/config".source = ../home/git/config;
        ".config/k9s/aliases.yaml".source = ../home/k9s/aliases.yaml;
        ".config/k9s/config.yaml".source = ../home/k9s/config.yaml;
        ".config/lazygit/config.yml".source = ../home/lazygit/config.yml;
        ".config/mimeapps.list".source = ../home/mimeapps.list;
        ".local/share/applications/mimeapps.list".source = ../home/mimeapps.list;
        ".config/posting/config.yaml".source = ../home/posting/config.yaml;
        ".config/starship.toml".source = ../home/starship.toml;
        ".config/user-dirs.dirs".source = ../home/user-dirs.dirs;

        # symlinks
        ".config/dms".source = mkSym "home/dms";
        ".config/ghostty".source = mkSym "home/ghostty";
        ".config/niri".source = mkSym "home/niri";
        ".config/pi".source = mkSym "home/pi";

        # cyberdream themes
        ".config/dms/themes/cyberdream-muted.json".source = "${thm.dux}/cyberdream-muted.json";
        ".config/pi/themes/cyberdream-muted.json".source = "${thm.pi}/cyberdream-muted.json";
        ".config/bat/themes/cyberdream.tmTheme".source = "${thm.textmate}/cyberdream-muted.tmTheme";
        ".config/btop/themes/cyberdream.theme".source = "${thm.btop}/cyberdream-muted.theme";
        ".config/k9s/skins/cyberdream.yaml".source = "${thm.k9s}/cyberdream-muted.yml";
        ".config/ghostty/theme.conf".source = "${thm.ghostty}/cyberdream-muted";
        ".config/posting/themes/cyberdream.yaml".source = "${thm.posting}/cyberdream-muted.yaml";
      };
    };
}
