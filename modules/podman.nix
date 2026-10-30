{ ... }:
{
  den.aspects.podman = {
    nixos =
      { pkgs, ... }:
      {
        environment = {
          systemPackages = [ pkgs.docker-compose ];
          variables.PODMAN_COMPOSE_WARNING_LOGS = "false";
        };

        virtualisation.podman = {
          enable = true;

          dockerCompat = true;
          dockerSocket.enable = true;

          autoPrune = {
            enable = true;
            flags = [
              "--filter=until=7d"
            ];
          };
          defaultNetwork.settings.dns_enabled = true;
        };

        users.users.scott = {
          # Subuid/subgid ranges for rootless userns mapping
          subUidRanges = [
            {
              startUid = 100000;
              count = 65536;
            }
          ];
          subGidRanges = [
            {
              startGid = 100000;
              count = 65536;
            }
          ];
        };
      };
  };
}
