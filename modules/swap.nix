{ ... }:
{
  den.aspects.core = {
    includes = [
      (
        { host, ... }:
        {
          nixos.swapDevices = [
            {
              device = "/swapfile";
              size = host.swapSize;
            }
          ];
        }
      )
    ];
  };
}
