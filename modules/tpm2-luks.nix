{ ... }:
{
  den.aspects.core = {
    includes = [
      (
        { host, lib, ... }:
        {
          nixos.boot.initrd.luks.devices = lib.mkMerge (
            map (deviceName: {
              ${deviceName}.crypttabExtraOpts = [
                "tpm2-device=auto"
                "headless=yes"
                "timeout=10s"
              ];
            }) (host.luksDevices or [ ])
          );
        }
      )
    ];

    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          tpm2-tss
          tpm2-tools
        ];
      };
  };
}
