{ utils, ... }:
{
  den.aspects.voxtype.hjem =
    { pkgs, ... }:
    let
      settings = {
        engine = "whisper";
        state_file = "auto";
        hotkey.enabled = false;
        osd.enabled = false;
      };
    in
    {
      packages = [ pkgs.voxtype-vulkan ];
      systemd.services.voxtype = utils.mkWaylandService {
        description = "Voxtype push-to-talk voice-to-text daemon";
        execStart = "${pkgs.voxtype-vulkan}/bin/voxtype daemon";
        extraServiceConfig = {
          RestartSec = 5;
        };
      };
      files = {
        ".config/voxtype/config.toml".source =
          (pkgs.formats.toml { }).generate "voxtype-config.toml"
            settings;
      };
    };
}
