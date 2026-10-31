{ ... }:
{
  den.aspects.zsh = {
    nixos =
      { config, pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.eza ];

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          silent = true;
        };

        programs.bat = {
          enable = true;
          settings.theme = "cyberdream";
        };

        programs.fzf = {
          fuzzyCompletion = true;
          keybindings = true;
        };

        programs.starship = {
          enable = true;
          enableZshIntegration = true;
        };

        programs.zoxide = {
          enable = true;
          enableZshIntegration = true;
          flags = [
            "--cmd"
            "cd"
          ];
        };

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          enableBashCompletion = true;
          autosuggestions.enable = true;
          syntaxHighlighting = {
            enable = true;
            styles = {
              default = "fg=#ffffff";
              unknown-token = "fg=#e8796f,bold";
              reserved-word = "fg=#e3c875";
              suffix-alias = "fg=#e878d8,underline";
              global-alias = "fg=#7ed8e8";
              precommand = "fg=#7ee088,underline";
              commandseparator = "fg=#7b8496";
              autodirectory = "fg=#7ee088,underline";
              path = "fg=#78a8e8,underline";
              path_pathseparator = "fg=#78a8e8";
              path_prefix_pathseparator = "fg=#78a8e8";
              globbing = "fg=#e878d8";
              history-expansion = "fg=#e878d8";
              command-substitution = "fg=#ffffff";
              command-substitution-delimiter = "fg=#e878d8";
              process-substitution = "fg=#ffffff";
              process-substitution-delimiter = "fg=#e878d8";
              single-hyphen-option = "fg=#e3c875";
              double-hyphen-option = "fg=#e3c875";
              back-quoted-argument = "fg=#ffffff";
              back-quoted-argument-delimiter = "fg=#e878d8";
              single-quoted-argument = "fg=#e3c875";
              double-quoted-argument = "fg=#e3c875";
              dollar-quoted-argument = "fg=#e3c875";
              rc-quote = "fg=#7ed8e8";
              dollar-double-quoted-argument = "fg=#7ed8e8";
              back-double-quoted-argument = "fg=#7ed8e8";
              back-dollar-quoted-argument = "fg=#7ed8e8";
              assign = "fg=#ffffff";
              redirection = "fg=#78a8e8";
              comment = "fg=#7b8496";
              named-fd = "fg=#ffffff";
              numeric-fd = "fg=#ffffff";
              arg0 = "fg=#7ee088";
            };
          };
          promptInit = "";
          histSize = 100000;
          histFile = "$HOME/.local/state/zsh/history";
          compInitDumpFile = "$HOME/.cache/zcompdump";
          setOptions = [
            "correct"
            "extended_history"
            "hist_fcntl_lock"
            "hist_ignore_all_dups"
            "hist_ignore_space"
            "hist_reduce_blanks"
            "interactive_comments"
            "share_history"
          ];
          shellAliases = {
            cat = "bat";
            eza = "eza --icons=auto --git --group-directories-first";
            la = "eza -a --icons=auto --git --group-directories-first";
            ll = "eza -l --icons=auto --git --group-directories-first";
            lla = "eza -la --icons=auto --git --group-directories-first";
            ls = "eza --icons=auto --git --group-directories-first";
            lt = "eza --tree --level=2 --icons=auto --git --group-directories-first";
            mt = "sudo modprobe -r hid_multitouch && sudo modprobe hid_multitouch";
            rebuild = "nh os switch ${config.users.users.scott.home}/git/nix";
            s = "ssh";
            v = "nvim";
            vi = "nvim";
            vim = "nvim";
          };
          interactiveShellInit = ''
            [[ -r ${config.hjem.users.scott.environment.loadEnv} ]] \
              && source ${config.hjem.users.scott.environment.loadEnv}
            mkdir -p "$HOME/.local/state/zsh"
            bindkey -e
            zmodload zsh/terminfo
            bindkey "''${terminfo[kcuu1]}" history-beginning-search-backward
            bindkey "''${terminfo[kcud1]}" history-beginning-search-forward
          '';
        };

        environment.sessionVariables = {
          BUN_INSTALL = "${config.users.users.scott.home}/.local/share/bun";
          DOCKER_CONFIG = "${config.users.users.scott.home}/.config/docker";
          GOPATH = "${config.users.users.scott.home}/.local/share/go";
          KUBECONFIG = "${config.users.users.scott.home}/.config/kube/config";
          NPM_CONFIG_CACHE = "${config.users.users.scott.home}/.cache/npm";
          NUGET_PACKAGES = "${config.users.users.scott.home}/.local/share/nuget";
          PI_CODING_AGENT_DIR = "${config.users.users.scott.home}/.config/pi";
          TALOSCONFIG = "${config.users.users.scott.home}/.config/talos/config";
        };
      };
  };
}
