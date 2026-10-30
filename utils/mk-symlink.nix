# mkSymlink — returns a store derivation that is a symlink to an
# out-of-store path. Use as a hjem files."<rel>".source value.
repoRoot: pkgs: relative:
let
  isString = builtins.isString relative;
  target = repoRoot + "/${relative}";
  nonEmpty = relative != "";
in
assert
  isString || throw "mkSymlink: relative path must be a string, got ${builtins.typeOf relative}";
assert nonEmpty || throw "mkSymlink: relative path must not be empty";

pkgs.runCommandLocal (baseNameOf target) { } "ln -s ${target} $out"
