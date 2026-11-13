{ ... }:
{
  den.aspects.azurite = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.azurite ];

        systemd.services.azurite = {
          description = "Azurite Azure Storage Emulator";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.azurite}/bin/azurite";
            Restart = "always";
            User = "azurite";
            Group = "azurite";
            StateDirectory = "azurite";
            WorkingDirectory = "/var/lib/azurite";
          };
        };

        users.users.azurite = {
          isSystemUser = true;
          group = "azurite";
          description = "Azurite service user";
        };

        users.groups.azurite = { };
      };
  };
}
