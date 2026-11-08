{ inputs }:
[
  (import ./channels.nix { inherit inputs; })
  (import ./nvim-nightly.nix { inherit inputs; })
]
