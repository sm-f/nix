{ utils, ... }:
{
  den.aspects.niri-session = {
    nixos =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      lib.mkIf config.programs.niri.enable {
        environment.systemPackages = [ pkgs.udiskie ];

        systemd.user.services.udiskie = utils.mkWaylandService {
          description = "udiskie - automounter for removable media";
          execStart = "${pkgs.udiskie}/bin/udiskie";
        };
      };
  };
}
