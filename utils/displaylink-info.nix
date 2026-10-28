# Emit a shell-safe `name=... url=...` assignment for the vendor zip that
# nixpkgs' displaylink package expects. We overlay requireFile so the
# requirement message itself becomes readable instead of failing the build.
let
  getFlake = builtins.getAttr "getFlake" builtins;
  flake = getFlake (toString ./..);
  pkgs = import flake.inputs.nixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    overlays = [
      (final: prev: {
        requireFile = args: args;
      })
    ];
  };
  src = pkgs.displaylink.src;
  msg = src.message;
  urlPattern = ".*(https://www\\.synaptics\\.com/sites/default/files/exe_files/[^ \n]+).*";
  matches = builtins.match urlPattern msg;
in
if matches == null then
  throw ''
    displaylink-info: could not extract a Synaptics download URL from the
    displaylink src message. The upstream package message format may have
    changed. Message was:
    ${msg}
  ''
else
  "name=${pkgs.lib.escapeShellArg src.name} url=${pkgs.lib.escapeShellArg (builtins.head matches)}"
