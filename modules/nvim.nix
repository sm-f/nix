{ utils, inputs, ... }:
{
  den.aspects.nvim.hjem =
    { pkgs, ... }:
    let
      mkSym = utils.mkSymlink pkgs;
    in
    {
      packages = with pkgs; [
        bash-language-server
        copilot-language-server
        emmylua-ls
        gh-markdown-preview
        neovim
        nixd
        nixfmt
        pi-coding-agent
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
        ".config/pi".source = mkSym "dotfiles/pi";
        ".local/share/applications/nvim-xdg.desktop".source = ../dotfiles/applications/nvim-xdg.desktop;
        ".config/pi/themes/cyberdream-muted.json".source =
          "${inputs.cyberdream.extras.pi}/cyberdream-muted.json";
      };
    };
}
