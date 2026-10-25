{ inputs, lib, ... }:
{
  den.aspects.niri = {
    nixos =
      { pkgs, config, ... }:
      {
        programs.niri = {
          enable = lib.mkForce true;
          package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        };

        environment.systemPackages = with pkgs; [
          adw-gtk3
          adwaita-icon-theme
          cliphist
          cups-pk-helper
          ghostty
          libnotify
          libsecret
          playerctl
          tela-icon-theme
          wl-clipboard
          wl-mirror
          xwayland-satellite
        ];

        services.upower.enable = true;
        services.udisks2.enable = true;
        # TDOO: Add dux-files when 576721 lands in nixpkgs.
        # This will replace nautilus.
        programs.dux-shell.enable = true;
        programs.dux-shell.systemd.enable = true;
        services.displayManager.dux-greeter = {
          enable = true;
          compositor.name = "niri";
          configHome = config.users.users.scott.home;
          compositor.customConfig = ''
            output "GIGA-BYTE TECHNOLOGY CO., LTD. G34WQC 20482B004420" {
                mode      "3440x1440@144"
                scale     1
                transform "normal"
                position  x=0 y=0
                focus-at-startup
            }
            output "Sharp Corporation LQ144P1JX01 0x340012A0" {
                mode      "2400x1600@120"
                scale     1.2
                position  x=920 y=1080
            }
            output "Dell Inc. DELL P2319H H5FH3V2" { off; }
            output "PNP(AOC) 24G2W1G5 0x00002294" { off; }
            output "PNP(AOC) 24G2W1G5 0x00002384" { off; }
            hotkey-overlay { skip-at-startup; }
            overview { backdrop-color "#000000"; }
            layout { background-color "#000000"; }
            cursor {
                xcursor-theme "Adwaita";
                xcursor-size 18
            }
          '';
        };

        programs.uwsm = {
          enable = true;
          waylandCompositors.niri = {
            prettyName = "Niri";
            comment = "Niri compositor managed by UWSM";
            binPath = "/run/current-system/sw/bin/niri-session";
          };
        };
      };
  };
}
