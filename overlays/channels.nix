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

  small = mkChannel inputs.nixpkgs-small;
  stable = mkChannel inputs.nixpkgs-stable;
in
{
  channels = { inherit small stable; };

  # small
  dux-files = small.dux-files;
  dux-greeter = small.dux-greeter;
  dux-search = small.dux-search;
  dux-shell = small.dux-shell;

  # stable
  azure-cli = stable.azure-cli;
  azure-functions-core-tools = stable.azure-functions-core-tools;
  bicep = stable.bicep;
}
