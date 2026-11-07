{ inputs, ... }:
let
  variant = "muted";
in
{
  _module.args.theme = import ../utils/cyberdream.nix { inherit inputs variant; };
}
