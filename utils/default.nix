let
  repoRoot = "/home/scott/git/nix";
in
{
  mkSymlink = import ./mk-symlink.nix repoRoot;
  mkWaylandService = import ./mk-wayland-service.nix;
}
