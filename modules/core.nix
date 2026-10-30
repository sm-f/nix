{ ... }:
{
  den.aspects.core = {
    nixos =
      { pkgs, ... }:
      {
        nix.settings = {
          warn-dirty = false;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          substituters = [
            "https://cache.nixos.org"
            "https://scottmckendry.cachix.org"
          ];
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "scottmckendry.cachix.org-1:jB2i6xNpH0TiZfTe2p3VfIejB3nUT8bf7PYsn9uOV3I="
          ];
        };

        fonts = {
          enableDefaultPackages = false;
          fontconfig = {
            enable = true;
            defaultFonts = {
              monospace = [ "JetBrainsMono Nerd Font" ];
              serif = [ "Inter" "Noto Serif CJK SC" ];
              sansSerif = [ "Inter" "Noto Sans CJK SC" ];
              emoji = [ "Noto Color Emoji" ];
            };
          };
          packages = with pkgs; [
            geist-font
            inter
            nerd-fonts.jetbrains-mono
            noto-fonts
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji
          ];
        };

        services.automatic-timezoned.enable = true;
        i18n = {
          defaultLocale = "en_NZ.UTF-8";
          supportedLocales = [
            "en_NZ.UTF-8/UTF-8"
            "en_GB.UTF-8/UTF-8"
          ];
        };

        programs.nix-ld.enable = true;
        programs.dconf = {
          enable = true;
          profiles.user.databases = [
            {
              settings."org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
                font-name = "Inter 9";
                document-font-name = "Inter 9";
                monospace-font-name = "JetBrainsMono Nerd Font 10";
              };
            }
          ];
        };
        programs.nh = {
          enable = true;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
        };

        # VA-API hardware video decode (Intel)
        hardware.graphics.enable = true;
        hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];

        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = import ../overlays;
        boot.kernelPackages = pkgs.linuxPackages_latest;
        system.stateVersion = "26.05";
      };
  };
}
