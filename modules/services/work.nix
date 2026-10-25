{ inputs, ... }:
{
  den.aspects.work = {
    nixos =
      { pkgs, ... }:
      let
        stablePkgs = inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system};

        azure-cli = stablePkgs.azure-cli;
        azure-functions-core-tools = stablePkgs.azure-functions-core-tools;
        bicep = stablePkgs.bicep;

        dotnet-combined =
          with pkgs.dotnetCorePackages;
          combinePackages [
            sdk_10_0
            sdk_9_0
            sdk_8_0
          ];
      in
      {
        services.twingate.enable = true;

        environment.systemPackages = with pkgs; [
          (azure-cli.withExtensions [
            azure-cli.extensions.azure-devops
            azure-cli.extensions.ssh
          ])
          ansible
          azure-functions-core-tools
          azurite
          bicep
          csharp-ls
          dbeaver-bin
          dotnet-combined
          keepass
          keepassxc
          libreoffice
          remmina
          teams-for-linux
        ];

        environment.sessionVariables = {
          DOTNET_ROOT = "${dotnet-combined}/share/dotnet";
          DOTNET_MULTILEVEL_LOOKUP = "0";
        };

        systemd.services.azurite = {
          description = "Azurite Azure Storage Emulator";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.azurite}/bin/azurite";
            Restart = "always";
            User = "azurite";
            Group = "azurite";
            StateDirectory = "azurite";
            WorkingDirectory = "/var/lib/azurite";
          };
        };

        users.users.azurite = {
          isSystemUser = true;
          group = "azurite";
          description = "Azurite service user";
        };

        users.groups.azurite = { };
      };
  };
}
