{ utils, ... }:
let
  settings = {
    engine = "whisper";
    state_file = "auto";
    hotkey.enabled = false;
    osd.enabled = false;
    whisper = {
      model = "base.en";
      language = "en";
    };
  };
in
{
  den.aspects.voxtype = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.voxtype-vulkan ];
        systemd.user.services.voxtype = utils.mkWaylandService {
          description = "Voxtype push-to-talk voice-to-text daemon";
          execStart = "${pkgs.voxtype-vulkan}/bin/voxtype daemon";
          extraServiceConfig = {
            RestartSec = 5;
          };
        };
      };

    hjem =
      { pkgs, ... }:
      {
        files = {
          ".config/voxtype/config.toml".source =
            (pkgs.formats.toml { }).generate "voxtype-config.toml"
              settings;
          ".local/share/voxtype/models/ggml-base.en.bin".source = pkgs.fetchurl {
            url = "https://huggingface.co/ggerganov/whisper.cpp/resolve/main/ggml-base.en.bin";
            hash = "sha256-oDd5yG3zMjB19eeWyyzlAp8A7Ihp7uP9+4l6/jbG0AI=";
          };
        };
      };
  };
}
