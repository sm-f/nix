{ ... }:
{
  den.aspects.office = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          dbeaver-bin
          keepass
          keepassxc
          libreoffice
          remmina
          teams-for-linux
        ];
      };
  };
}
