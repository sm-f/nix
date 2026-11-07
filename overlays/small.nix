# Packages that should be pulled from the faster-moving nixos-unstable-small
# channel instead of the nixos-unstable base.
{ inputs }:
_final: prev:
let
  small = import inputs.nixpkgs-small {
    inherit (prev.stdenv.hostPlatform) system;
    config = prev.config;
  };

  smallPackages = [
    "dux-files"
    "dux-greeter"
    "dux-search"
    "dux-shell"
  ];
in
prev.lib.genAttrs smallPackages (name: small.${name})
