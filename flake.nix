{
  outputs =
    inputs:
    (inputs.nixpkgs.lib.evalModules {
      modules = [ (import ./utils/import-tree.nix ./modules) ];
      specialArgs.inputs = inputs;
    }).config.flake;

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";

    cyberdream = {
      url = "github:scottmckendry/cyberdream.nvim";
    };

    den = {
      url = "github:vic/den";
    };

    niri = {
      url = "github:niri-wm/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
