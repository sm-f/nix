# mkSymlink — returns a store derivation that is a symlink to an
# out-of-store path. Use as a hjem files."<rel>".source value.
pkgs: target:
let
  isString = builtins.isString target;
  nonEmpty = target != "";
  isAbsolute = (builtins.substring 0 1 target) == "/";
in
assert isString || throw "mkSymlink: target must be a string, got ${builtins.typeOf target}";
assert nonEmpty || throw "mkSymlink: target must not be empty";
assert isAbsolute || throw "mkSymlink: target must be absolute path, got '${target}'";

pkgs.runCommandLocal (baseNameOf target) { } "ln -s ${target} $out"
