{ inputs, lib, ... }:
{
  den.aspects.librewolf.hjem =
    { pkgs, ... }:
    let
      stablePkgs = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};
      extensions = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          slug = "bitwarden-password-manager";
          private = true;
        };
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          slug = "sidebery";
        };
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
          slug = "refined-github-";
        };
        "ATBC@EasonWong" = {
          slug = "adaptive-tab-bar-colour";
        };
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          slug = "vimium-ff";
        };
      };

      extensionSettings = builtins.mapAttrs (
        _: ext:
        {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/${ext.slug}/latest.xpi";
        }
        // lib.optionalAttrs (ext.private or false) { private_browsing = true; }
      ) extensions;
    in
    {
      clobberFiles = true;

      packages = [
        (stablePkgs.librewolf.override {
          extraPolicies.ExtensionSettings = extensionSettings;
        })
      ];

      files = {
        ".librewolf/profiles.ini".source = ../home/librewolf/profiles.ini;
        ".librewolf/default/user.js".source = ../home/librewolf/user.js;
        ".librewolf/default/chrome/userChrome.css".source = ../home/librewolf/userChrome.css;
      };
    };
}
