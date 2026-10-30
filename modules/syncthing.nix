{ ... }:
{
  den.aspects.syncthing = {
    nixos =
      { config, ... }:
      {
        services.syncthing = {
          enable = true;
          user = "scott";
          group = "users";
          dataDir = "${config.users.users.scott.home}/Documents/syncthing";
        };
      };
  };
}
