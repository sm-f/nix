{ theme, lib, ... }:
{
  den.aspects.git = {
    settings = {
      name = lib.mkOption {
        type = lib.types.str;
        description = "Git author name";
      };
      email = lib.mkOption {
        type = lib.types.str;
        description = "Git author email";
      };
    };

    hjem =
      { pkgs, user, ... }:
      let
        cfg = user.settings.git;

        gitConfig = {
          user = {
            name = cfg.name;
            email = cfg.email;
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
          os = {
            open = "xdg-open {{filename}}";
            openLink = "xdg-open {{link}}";
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
  };
}
