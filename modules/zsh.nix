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

        environment.etc."zsh/.zshrc".text = ''
          # System configuration is loaded from /etc/zshrc. This file only
          # exists to suppress zsh-newuser-install.
        '';

        programs.zsh = {
          enable = true;
          enableCompletion = true;
          enableBashCompletion = true;
          autosuggestions.enable = true;
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
            zmodload zsh/terminfo
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
          ZDOTDIR = "/etc/zsh";
        };
      };
  };
}
