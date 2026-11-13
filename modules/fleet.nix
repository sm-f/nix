# Fleet-wide facts that every host used to guess from a literal path or
# username. Hosts set these in `den.hosts.<system>.<name>.settings.fleet`.
{ lib, ... }:
{
  den.aspects.fleet = {
    settings = {
      primaryUser = lib.mkOption {
        type = lib.types.str;
        description = "User account that owns the config checkout and desktop session";
      };

      repoRoot = lib.mkOption {
        type = lib.types.str;
        description = "Absolute path to this flake's working tree";
      };

      cachix = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.submodule {
            options = {
              name = lib.mkOption { type = lib.types.str; };
              publicKey = lib.mkOption { type = lib.types.str; };
            };
          }
        );
        default = null;
        description = "Optional personal cachix cache";
      };
    };
  };
}
