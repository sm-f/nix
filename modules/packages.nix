{ ... }:
{
  den.aspects.packages = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          btop
          delta
          fd
          fetch
          gcc
          gh
          git
          gnumake
          jq
          just
          k9s
          killall
          lazygit
          nodejs
          openssl
          pi-coding-agent
          powershell
          python3
          ripgrep
          tokei
          tree
          unzip
          vlc
          wget
          zizmor
        ];
      };
  };
}
