{ ... }:
{
  den.aspects.zsh = {
    nixos =
      { config, pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          bat
          eza
          fzf
          starship
          zoxide
        ];

        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
          silent = true;
        };

        programs.zsh = {
          enableCompletion = true;
          autosuggestions.enable = true;
          promptInit = "";
          setOptions = [ "correct" ];
          shellAliases = {
            cat = "bat";
            cd = "z";
            cdi = "zi";
            eza = "eza --icons auto --git --group-directories-first";
            la = "eza -a";
            ll = "eza -l";
            lla = "eza -la";
            ls = "eza";
            lt = "eza --tree";
            rebuild = "nh os switch .";
            s = "ssh";
          };
          interactiveShellInit = ''
            source ${config.hjem.users.scott.environment.loadEnv}
            eval "$(zoxide init zsh)"
            eval "$(starship init zsh)"
          '';
        };

        environment.sessionVariables = {
          BUN_INSTALL = "$HOME/.local/share/bun";
          DOCKER_CONFIG = "$HOME/.config/docker";
          GOPATH = "$HOME/.local/share/go";
          KUBECONFIG = "$HOME/.config/kube/config";
          NPM_CONFIG_CACHE = "$HOME/.cache/npm";
          NUGET_PACKAGES = "$HOME/.local/share/nuget";
          PI_CODING_AGENT_DIR = "$HOME/.config/pi";
          TALOSCONFIG = "$HOME/.config/talos/config";
        };
      };
  };
}
