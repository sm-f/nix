{ ... }:
{
  den.aspects.zsh = {
    nixos =
      { pkgs, ... }:
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
          setOptions = [ "correct" ];
          ohMyZsh = {
            enable = true;
            plugins = [ "git" ];
          };
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
            eval "$(zoxide init zsh)"
            eval "$(starship init zsh)"
          '';
        };

        environment.sessionVariables = {
          BUN_INSTALL = "$HOME/.local/share/bun";
          DOCKER_CONFIG = "$HOME/.config/docker";
          EDITOR = "nvim";
          GOPATH = "$HOME/.local/share/go";
          KUBECONFIG = "$HOME/.config/kube/config";
          MANPAGER = "nvim +Man!";
          NPM_CONFIG_CACHE = "$HOME/.cache/npm";
          NUGET_PACKAGES = "$HOME/.local/share/nuget";
          OBSIDIAN_PATH = "$HOME/Documents/obsidian";
          PI_CODING_AGENT_DIR = "$HOME/.config/pi";
          TALOSCONFIG = "$HOME/.config/talos/config";
        };
      };
  };
}
