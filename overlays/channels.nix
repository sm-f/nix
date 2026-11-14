# pin packages to specific channels other than the default nixos-unstable channel
{ inputs }:
_final: prev:
let
  mkChannel =
    input:
    import input {
      inherit (prev.stdenv.hostPlatform) system;
      config = prev.lib.filterAttrs (_: value: value != null) prev.config;
    };

  stable = mkChannel inputs.nixpkgs-stable;
in
{
  channels = { inherit stable; };

  azure-cli = stable.azure-cli;
  azure-functions-core-tools = stable.azure-functions-core-tools;
  bicep = stable.bicep;
}
