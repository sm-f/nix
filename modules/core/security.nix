{ lib, ... }:
{
  den.aspects.security = {
    settings.u2fKeys = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "PAM u2f authfile entries, keyed by user name";
    };

    nixos =
      { host, ... }:
      let
        keys = host.settings.security.u2fKeys;
      in
      {
        # howdy: IR face auth (Windows Hello-style)
        services.howdy = {
          enable = true;
          control = "sufficient";
        };

        # IR emitter support for howdy
        services.linux-enable-ir-emitter = {
          enable = true;
        };

        # pam_u2f authfile: key handles + EC public keys.
        # Format: user:handle,pubkey,es256,+presence[:handle,...]
        environment.etc."u2f_keys".text = lib.concatStringsSep "\n" (
          lib.mapAttrsToList (user: value: "${user}:${value}") keys
        );

        security.pam = {
          u2f.settings.cue = true;
          u2f.settings.authfile = "/etc/u2f_keys";
          services = {
            login.u2fAuth = true;
            login.enableGnomeKeyring = true;
            sudo.u2fAuth = true;
            su.u2fAuth = true;
            quickshell.u2fAuth = true;
            quickshell.enableGnomeKeyring = true;
          };
        };
      };
  };
}
