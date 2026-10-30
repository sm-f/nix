{ ... }:
{
  den.aspects.niri-session = {
    nixos =
      {
        pkgs,
        config,
        lib,
        ...
      }:
      let
        dir = "${config.users.users.scott.home}/.config/niri";
        niri-select-outputs = pkgs.writeShellApplication {
          name = "niri-select-outputs";
          runtimeInputs = [ pkgs.usbutils ];
          text = ''
            set -euo pipefail

            if lsusb -d 17e9:6006 >/dev/null 2>&1; then
              target=docked
            else
              target=mobile
            fi

            ln -sfn "${dir}/output-$target.kdl" "${dir}/output-active.kdl"
            echo "niri outputs: $target"
          '';
        };
      in
      lib.mkIf config.programs.niri.enable {
        environment.systemPackages = [ niri-select-outputs ];
        systemd.user.services.niri-select-outputs = {
          description = "Select niri output config based on dock presence";
          before = [ "graphical-session-pre.target" ];
          wantedBy = [ "graphical-session-pre.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${niri-select-outputs}/bin/niri-select-outputs";
          };
        };

        # re-select niri outputs on Dell D6000 dock connect/disconnect
        services.udev.extraRules = ''
          ACTION=="add|remove", \
          SUBSYSTEM=="usb", \
          ENV{DEVTYPE}=="usb_device", \
          ENV{PRODUCT}=="17e9/6006/*", \
          RUN+="${niri-select-outputs}/bin/niri-select-outputs"
        '';
      };
  };
}
