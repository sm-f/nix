{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.nautilus
          pkgs.sushi
        ];
        services.dbus.packages = [ pkgs.sushi ];
        services.gvfs.enable = true;
        services.gnome.localsearch.enable = true;
        services.gnome.tinysparql.enable = true;

        programs.dconf.profiles.user.databases = [
          {
            settings."org/gnome/nautilus/preferences" = {
              fts-enabled = false;
            };
          }
        ];
      };
  };
}
