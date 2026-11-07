{ den, ... }:
{
  den.aspects.scott = {
    includes = [
      den.aspects.dotfiles
      den.aspects.git
      den.aspects.ghostty
      den.aspects.librewolf
      den.aspects.nvim
      den.aspects.voxtype
      den.provides.define-user
      den.provides.primary-user
      (den.provides.user-shell "nushell")
    ];
  };

  den.aspects.eris = {
    includes = with den.aspects; [
      core
      displaylink
      power-management
      intune
      networking
      niri
      packages
      podman
      shells
      syncthing
      work
    ];

    nixos =
      { config, lib, ... }:
      {
        imports = [
          ./_eris-hardware.nix
        ];

        # Disable NVIDIA GPU entirely - use Intel GPU only
        boot.blacklistedKernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_uvm"
          "nvidia_drm"
          "nouveau"
        ];

        # Touchpad sensitivity overrides
        # see https://wayland.freedesktop.org/libinput/doc/latest/touchpad-pressure-debugging.html
        environment.etc."libinput/local-overrides.quirks".text = ''
          [Touchpad Sensitivity Overrides]
          MatchVendor=0x045E
          MatchProduct=0x09AF
          MatchUdevType=touchpad
          AttrPressureRange=5:3
          AttrPalmPressureThreshold=500
        '';

        nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
  };
}
