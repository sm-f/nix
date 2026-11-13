{ den, ... }:
{
  den.aspects.core.includes = with den.aspects; [
    fleet
    boot
    security
    swap
    luks
    nix-update
    nix-settings
    locale
    fonts
    hjem
  ];
}
