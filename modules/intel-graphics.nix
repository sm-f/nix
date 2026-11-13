{ ... }:
{
  den.aspects.intel-graphics = {
    nixos =
      { pkgs, ... }:
      {
        # VA-API hardware video decode (Intel)
        hardware.graphics.enable = true;
        hardware.graphics.extraPackages = [ pkgs.intel-media-driver ];
      };
  };
}
