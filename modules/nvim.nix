{ utils, ... }:
{
  den.aspects.nvim.hjem =
    { pkgs, ... }:
    let
      mkSym = utils.mkSymlink pkgs;
    in
    {
      clobberFiles = true;

      packages = with pkgs; [
        bash-language-server
        copilot-language-server
        emmylua-ls
        gh-markdown-preview
        neovim
        nixd
        nixfmt
        powershell-editor-services
        prettier
        shfmt
        stylua
        tailwindcss-language-server
        taplo
        tree-sitter
        vscode-langservers-extracted
        yaml-language-server
      ];

      files = {
        ".config/nvim".source = mkSym "nvim";
        ".local/share/applications/nvim-xdg.desktop".source = ../home/applications/nvim-xdg.desktop;
      };
    };
}
