{ ... }:
{
  den.aspects.packages = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          bash-language-server
          btop
          delta
          emmylua-ls
          fd
          fetch
          gcc
          gh
          gh-markdown-preview
          git
          gnumake
          jq
          just
          k9s
          killall
          lazygit
          neovim
          nixd
          nixfmt
          nodejs
          openssl
          pi-coding-agent
          powershell
          powershell-editor-services
          prettier
          python3
          restic
          ripgrep
          shfmt
          stylua
          tokei
          tree
          tree-sitter
          unzip
          vlc
          vscode-langservers-extracted
          wget
          yaml-language-server
          zizmor
        ];
      };
  };
}
