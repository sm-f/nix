{
  den,
  inputs,
  theme,
  utils,
  ...
}:
{
  den.aspects.niri = {
    includes = [ den.aspects.niri-select-outputs ];
    nixos =
      {
        config,
        host,
        pkgs,
        ...
      }:
      let
        home = config.users.users.${host.settings.fleet.primaryUser}.home;
      in
      {
        programs.niri = {
          enable = true;
          package = inputs.niri.packages.${pkgs.stdenv.hostPlatform.system}.niri;
        };

        environment.systemPackages = with pkgs; [
          adw-gtk3
          adwaita-icon-theme
          cliphist
          cups-pk-helper
          libnotify
          libsecret
          playerctl
          tela-icon-theme
          wl-clipboard
          wl-mirror
          xwayland-satellite
        ];

        services.gvfs.enable = true;
        services.upower.enable = true;
        services.udisks2.enable = true;

        programs.dux-files.enable = true;
        programs.dux-files.systemd.enable = true;
        programs.dux-search.enable = true;
        programs.dux-shell.enable = true;
        programs.dux-shell.systemd.enable = true;

        services.displayManager.dux-greeter = {
          enable = true;
          compositor.name = "niri";
          configHome = home;
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

    provides.to-users.hjem =
      { host, pkgs, ... }:
      let
        mkSym = utils.mkSymlink host.settings.fleet.repoRoot pkgs;
      in
      {
        files = {
          ".config/dfiles".source = mkSym "dotfiles/dfiles";
          ".config/dms".source = mkSym "dotfiles/dms";
          ".config/niri".source = mkSym "dotfiles/niri";
          ".config/dms/themes/cyberdream.json".source = theme.dux;
        };
      };
  };
}
