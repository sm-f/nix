{ ... }:
{
  den.aspects.core = {
    nixos =
      { pkgs, config, ... }:
      let
        user = config.users.users.scott;

        nix-update-check = pkgs.writeShellApplication {
          name = "nix-update-check";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.git
            pkgs.jq
            pkgs.nix
          ];
          text = ''
            readonly REPO_DIR="''${NIX_REPO_DIR:-$HOME/git/nix}"
            readonly CACHE="''${NIX_UPDATE_CACHE:-$HOME/.cache/nix-update-status}"

            resolved=$(mktemp)
            trap 'rm -f "$resolved"' EXIT

            if ! err=$(nix flake update --flake "$REPO_DIR" --output-lock-file "$resolved" 2>&1); then
              printf 'nix-update-check: flake update failed, leaving indicator untouched:\n%s\n' "$err" >&2
              exit 0 # offline or broken: leave the indicator untouched
            fi

            if jq -S . "$REPO_DIR/flake.lock" | cmp -s - <(jq -S . "$resolved"); then
              rm -f "$CACHE"
            else
              mkdir -p "$(dirname "$CACHE")"
              printf '' >"$CACHE"
            fi
          '';
        };
      in
      {
        systemd.timers.nix-update-check = {
          description = "Check for flake updates upstream";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "1min";
            OnUnitActiveSec = "7min";
          };
        };

        systemd.services.nix-update-check = {
          description = "Check for flake updates upstream";
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStart = "${nix-update-check}/bin/nix-update-check";
            TimeoutStartSec = "5min";
            Environment = [
              "HOME=${user.home}"
              "NIX_REPO_DIR=${user.home}/git/nix"
            ];
          };
        };
      };
  };
}
