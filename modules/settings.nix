# Typed, per-aspect settings. Hosts and users set values under `settings`;
# aspects declare options and read them back from their context entity.
{ den, lib, ... }:
let
  settingsModule = {
    options.settings = lib.mkOption {
      type = import ../utils/settings-type.nix { inherit den lib; };
      default = { };
      description = "Typed per-aspect settings";
    };
  };
in
{
  den.reservedKeys = [ "settings" ];

  den.schema.host.imports = [ settingsModule ];
  den.schema.user.imports = [ settingsModule ];
}
