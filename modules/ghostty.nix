{ inputs, utils, ... }:
{
  den.aspects.ghostty.hjem =
    { pkgs, ... }:
    let
      mkSym = utils.mkSymlink pkgs;
    in
    {
      packages = [ pkgs.ghostty ];
      files = {
        ".config/ghostty/config".source = mkSym "home/ghostty/config";
        ".config/ghostty/gtk.css".source = mkSym "home/ghostty/gtk.css";
        ".config/ghostty/themes".source = mkSym "home/ghostty/themes";
        ".config/ghostty/theme.conf".source = "${inputs.cyberdream.extras.ghostty}/cyberdream-muted";
      };
    };
}
