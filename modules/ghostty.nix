{ theme, utils, ... }:
{
  den.aspects.ghostty.hjem =
    { pkgs, ... }:
    let
      mkSym = utils.mkSymlink pkgs;
    in
    {
      packages = [ pkgs.ghostty ];
      files = {
        ".config/ghostty/config".source = mkSym "dotfiles/ghostty/config";
        ".config/ghostty/gtk.css".source = mkSym "dotfiles/ghostty/gtk.css";
        ".config/ghostty/themes".source = mkSym "dotfiles/ghostty/themes";
        ".config/ghostty/theme.conf".source = theme.ghostty;
      };
    };
}
