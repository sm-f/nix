{ inputs, lib, ... }:
{
  den.aspects.nix-settings = {
    nixos =
      { host, pkgs, ... }:
      let
        cache = host.settings.fleet.cachix;
      in
      {
        nix.settings = {
          warn-dirty = false;
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          substituters = [
            "https://cache.nixos.org"
          ]
          ++ lib.optional (cache != null) "https://${cache.name}.cachix.org";
          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          ]
          ++ lib.optional (cache != null) cache.publicKey;
        };

        programs.nix-ld.enable = true;
        programs.nh = {
          enable = true;
          flake = host.settings.fleet.repoRoot;
          clean.enable = true;
          clean.extraArgs = "--keep-since 4d --keep 3";
        };

        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = import ../../overlays { inherit inputs; };
        boot.kernelPackages = pkgs.linuxPackages_latest;
        system.stateVersion = "26.05";
      };
  };
}
