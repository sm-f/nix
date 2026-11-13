{ theme, utils, ... }:
{
  den.aspects.ghostty.hjem =
    { host, pkgs, ... }:
    let
      mkSym = utils.mkSymlink host.settings.fleet.repoRoot pkgs;
    in
    {
      packages = [ pkgs.ghostty ];
      files = {
        ".config/haunt/config.toml".source = mkSym "dotfiles/haunt/config.toml";
        ".config/ghostty/config".source = mkSym "dotfiles/ghostty/config";
        ".config/ghostty/gtk.css".source = mkSym "dotfiles/ghostty/gtk.css";
        ".config/ghostty/themes".source = mkSym "dotfiles/ghostty/themes";
        ".config/ghostty/theme.conf".source = theme.ghostty;
      };
    };
}
