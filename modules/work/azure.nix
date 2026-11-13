{ ... }:
{
  den.aspects.azure = {
    nixos =
      { pkgs, ... }:
      let
        dotnet-combined =
          with pkgs.dotnetCorePackages;
          combinePackages [
            sdk_10_0
            sdk_9_0
            sdk_8_0
          ];
      in
      {
        environment.systemPackages = with pkgs; [
          (azure-cli.withExtensions [
            azure-cli.extensions.azure-devops
            azure-cli.extensions.ssh
          ])
          ansible
          azure-functions-core-tools
          bicep
          csharp-ls
          dotnet-combined
        ];

        environment.sessionVariables = {
          DOTNET_ROOT = "${dotnet-combined}/share/dotnet";
          DOTNET_MULTILEVEL_LOOKUP = "0";
        };
      };
  };
}
