{ theme, ... }:
{
  den.aspects.shells = {
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      {
        environment.shells = [ pkgs.nushell ];
        environment.systemPackages = [
          pkgs.carapace
          pkgs.eza
        ];

        environment.sessionVariables = {
          BUN_INSTALL = "${config.users.users.scott.home}/.local/share/bun";
          CYBERDREAM_VARIANT = theme.variant;
          DOCKER_CONFIG = "${config.users.users.scott.home}/.config/docker";
          EDITOR = "nvim";
          GOPATH = "${config.users.users.scott.home}/.local/share/go";
          KUBECONFIG = "${config.users.users.scott.home}/.config/kube/config";
          MANPAGER = "nvim +Man!";
          NPM_CONFIG_CACHE = "${config.users.users.scott.home}/.cache/npm";
          NUGET_PACKAGES = "${config.users.users.scott.home}/.local/share/nuget";
          OBSIDIAN_PATH = "${config.users.users.scott.home}/Documents/obsidian";
          PI_CODING_AGENT_DIR = "${config.users.users.scott.home}/.config/pi";
          TALOSCONFIG = "${config.users.users.scott.home}/.config/talos/config";
          ZDOTDIR = "/etc/zsh";
        };

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
          settings = {
            format = "$all $fill $cmd_duration\n$character";

            fill.symbol = " ";
            golang.symbol = " ";

            add_newline = true;
            line_break.disabled = true;
            git_metrics.disabled = false;

            character = {
              error_symbol = "[❯](red)";
              success_symbol = "[❯](green)";
            };

            cmd_duration = {
              format = "[$duration](bright-black)";
              min_time = 10;
              show_milliseconds = true;
            };

            nix_shell = {
              symbol = "❄ ";
              format = "via [$symbol ($name)]($style) ";
            };
          };
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
            mkdir -p "$HOME/.local/state/zsh"
            zmodload zsh/terminfo
          '';
        };

        environment.etc."zsh/.zshrc".text = ''
          # System configuration is loaded from /etc/zshrc. This file only
          # exists to suppress zsh-newuser-install.
        '';

        programs.nushell = {
          enable = true;
          interactiveShellInit = ''
            $env.CARAPACE_BRIDGES = "zsh,fish,bash"
            $env.config.show_banner = "false"

            alias cat = bat
            alias rebuild = nh os switch ${config.users.users.scott.home}/git/nix
            alias s = ssh
            alias v = nvim
            alias vi = nvim
            alias vim = nvim

            def mt [] {
              sudo modprobe -r hid_multitouch
              sudo modprobe hid_multitouch
            }

            source /etc/nushell/carapace.nu
            source ${pkgs.fzf}/share/fzf/key-bindings.nu
            source /etc/nushell/fzf-completion.nu
            source /etc/nushell/zoxide.nu
          '';
        };

        environment.etc."nushell/carapace.nu".source = pkgs.runCommandLocal "carapace-init.nu" { } ''
          ${lib.getExe pkgs.carapace} _carapace nushell > $out
          sed -i '1c\$env.PATH = ($env.PATH | split row (char esep) | where { $in != ($env.HOME | path join ".config/carapace/bin") } | prepend ($env.HOME | path join ".config/carapace/bin"))' $out
        '';

        # TODO: Replace this backport with ${pkgs.fzf}/share/fzf/completion.nu once nixpkgs ships fzf > 0.74.5.
        environment.etc."nushell/fzf-completion.nu".source = pkgs.fetchurl {
          name = "fzf-completion.nu";
          url = "https://raw.githubusercontent.com/junegunn/fzf/55c122f1a0e1340546c8709682bea5561fe0e8fd/shell/completion.nu";
          hash = "sha256-O+2LEwn2A++nnvuwg/aFyZ+gfSQuEoMYsa9Q/pCyx1U=";
        };

        environment.etc."nushell/zoxide.nu".source = pkgs.runCommandLocal "zoxide-init.nu" { } ''
          ${lib.getExe pkgs.zoxide} init nushell --cmd cd > $out
        '';
      };
  };
}
