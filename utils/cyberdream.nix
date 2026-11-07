# Resolve every cyberdream extra for a single variant.
{
  inputs,
  variant,
}:
let
  inherit (inputs.nixpkgs) lib;

  suffix = if variant == "default" then "" else "-${variant}";
  base = "cyberdream${suffix}";

  # Pick the file for `base` from an extra directory, regardless of extension.
  fileFor =
    dir:
    let
      entries = builtins.readDir dir;
      matches = lib.filter (
        name: entries.${name} == "regular" && (name == base || lib.hasPrefix "${base}." name)
      ) (builtins.attrNames entries);
    in
    if matches == [ ] then null else "${dir}/${lib.head matches}";

  extras = lib.filterAttrs (_: value: value != null) (
    builtins.mapAttrs (_: fileFor) inputs.cyberdream.extras
  );
in
extras // { inherit variant; }
