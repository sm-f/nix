{ lib, ... }:
{
  den.aspects.power-management = {
    includes = [
      (
        { host, ... }:
        let
          resumeOffset = host.settings.swap.resumeOffset;
          luksDevices = host.settings.luks.devices;
        in
        {
          nixos = {
            boot.kernelParams = lib.optional (resumeOffset != null) "resume_offset=${toString resumeOffset}";
            boot.resumeDevice = lib.mkIf (luksDevices != [ ]) "/dev/mapper/${builtins.head luksDevices}";
          };
        }
      )
    ];

    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.brightnessctl ];

        powerManagement.enable = true;
        services.tlp = {
          enable = true;
          pd.enable = true;
          settings = {
            PCIE_ASPM_ON_BAT = "powersupersave";
            PLATFORM_PROFILE_ON_BAT = "low-power";
            RUNTIME_PM_ON_AC = "auto";
          };
        };
        services.power-profiles-daemon.enable = false; # conflicts with TLP
        systemd.sleep.settings.Sleep = {
          AllowHibernation = "yes";
          HibernateMode = "platform shutdown";
          HibernateDelaySec = "30m";
        };
        services.logind.settings.Login = {
          HandleLidSwitch = "suspend-then-hibernate";
          HandleLidSwitchExternalPower = "ignore";
          HandlePowerKey = "ignore";
          HandlePowerKeyLongPress = "poweroff";
        };
      };
  };
}
