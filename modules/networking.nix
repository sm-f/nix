{ ... }:
{
  den.aspects.networking = {
    includes = [
      (
        { host, ... }:
        {
          nixos.networking.hostName = host.hostName;
          nixos.environment.sessionVariables.HOSTNAME = host.hostName;
        }
      )
    ];

    nixos =
      { ... }:
      {
        networking.networkmanager.enable = true;

        hardware.bluetooth.enable = true;
        hardware.bluetooth.powerOnBoot = true;
      };
  };
}
