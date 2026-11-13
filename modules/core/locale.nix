{ lib, ... }:
{
  den.aspects.locale = {
    settings = {
      default = lib.mkOption {
        type = lib.types.str;
        default = "en_US.UTF-8";
        description = "Default system locale";
      };
      supported = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Additional supported locales";
      };
      automaticTimezone = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Track the timezone automatically using geoclue";
      };
    };

    nixos =
      { host, ... }:
      {
        services.automatic-timezoned.enable = host.settings.locale.automaticTimezone;

        i18n = {
          defaultLocale = host.settings.locale.default;
          supportedLocales = host.settings.locale.supported;
        };
      };
  };
}
