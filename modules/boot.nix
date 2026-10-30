{ ... }:
{
  den.aspects.core = {
    nixos =
      { pkgs, ... }:
      {
        boot = {
          loader = {
            systemd-boot.enable = false;
            efi.canTouchEfiVariables = true;
            timeout = 2;
          };

          plymouth = {
            enable = true;
            theme = "bgrt";
          };

          consoleLogLevel = 3;
          kernelParams = [
            "quiet"
            "boot.shell_on_fail"
            "udev.log_priority=3"
            "rd.systemd.show_status=auto"
            "systemd.show_status=0"
          ];

          loader.limine = {
            enable = true;
            maxGenerations = 20;
            secureBoot.enable = true;
          };
        };

        environment.systemPackages = [ pkgs.sbctl ];
      };
  };
}
