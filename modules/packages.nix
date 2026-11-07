{ ... }:
{
  den.aspects.packages = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          btop
          fd
          fetch
          gcc
          gnumake
          jq
          just
          k9s
          killall
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
