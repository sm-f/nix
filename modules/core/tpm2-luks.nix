{ lib, ... }:
{
  den.aspects.luks = {
    settings.devices = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "LUKS device mapper names to unlock at boot";
    };

    nixos =
      { host, pkgs, ... }:
      let
        cfg = host.settings.luks;
      in
      {
        boot.initrd.luks.devices = lib.mkMerge (
          map (deviceName: {
            ${deviceName}.crypttabExtraOpts = [
              "tpm2-device=auto"
              "headless=yes"
              "timeout=10s"
            ];
          }) cfg.devices
        );

        environment.systemPackages = with pkgs; [
          tpm2-tss
          tpm2-tools
        ];
      };
  };
}
