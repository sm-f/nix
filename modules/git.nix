{ theme, lib, ... }:
{
  den.aspects.git.hjem =
    { pkgs, ... }:
    let
      gitConfig = {
        user = {
          name = "Scott McKendry";
          email = "me@scottmckendry.tech";
        };
        alias = {
          co = "checkout";
          hist = "log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short";
        };
        delta = {
          side-by-side = true;
          syntax-theme = "cyberdream";
        };
        credential = {
          "https://github.com".helper = "!/usr/bin/env gh auth git-credential";
          "https://gist.github.com".helper = "!/usr/bin/env gh auth git-credential";
        };
      };

      lazygitConfig = {
        notARepository = "skip";
        gui = {
          mouseEvents = false;
          nerdFontsVersion = "3";
        };
        git = {
          diffRenderers = [
            {
              colorArg = "always";
              command = "delta --paging=never";
            }
          ];
          parseEmoji = true;
        };
      };

      lazygitConfigFile =
        pkgs.runCommandLocal "lazygit-config.yml"
          {
            baseConfig = pkgs.writeText "lazygit-base.yml" (lib.generators.toYAML { } lazygitConfig);
            theme = theme.lazygit;
            nativeBuildInputs = [ pkgs.yq-go ];
          }
          ''
            yq eval-all -P 'select(fi == 0) * select(fi == 1)' "$baseConfig" "$theme" > "$out"
          '';
    in
    {
      packages = with pkgs; [
        delta
        gh
        git
        lazygit
      ];
      files = {
        ".config/git/config".text = lib.generators.toGitINI gitConfig;
        ".config/lazygit/config.yml".source = lazygitConfigFile;
      };
    };
}
