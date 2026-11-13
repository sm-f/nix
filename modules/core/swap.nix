{ lib, ... }:
{
  den.aspects.swap = {
    settings = {
      size = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Swapfile size in MiB";
      };
      resumeOffset = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "Hibernation resume offset for the swapfile";
      };
    };

    nixos =
      { host, lib, ... }:
      let
        cfg = host.settings.swap;
      in
      {
        swapDevices = lib.optional (cfg.size != null) {
          device = "/swapfile";
          size = cfg.size;
        };
      };
  };
}
