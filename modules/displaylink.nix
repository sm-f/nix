{ ... }:
{
  den.aspects.displaylink = {
    nixos =
      { pkgs, config, ... }:
      {
        boot = {
          extraModulePackages = [ config.boot.kernelPackages.evdi ];
          kernelModules = [ "evdi" ];
        };

        environment.systemPackages = [ pkgs.displaylink ];
        services.xserver.videoDrivers = [
          "modesetting"
          "displaylink"
        ];

        # only run dlm.service when a DisplayLink device is connected
        services.udev.extraRules = ''
          ACTION=="add", SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="17e9", RUN+="${config.systemd.package}/bin/systemctl --no-block start dlm.service"
          ACTION=="remove", SUBSYSTEM=="usb", ENV{ID_VENDOR_ID}=="17e9", RUN+="${config.systemd.package}/bin/systemctl --no-block stop dlm.service"
        '';
      };
  };
}
