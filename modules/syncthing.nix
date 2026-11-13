{ ... }:
{
  den.aspects.syncthing = {
    nixos =
      { config, host, ... }:
      let
        user = host.settings.fleet.primaryUser;
      in
      {
        services.syncthing = {
          enable = true;
          user = user;
          group = "users";
          dataDir = "${config.users.users.${user}.home}/Documents/syncthing";
        };
      };
  };
}
