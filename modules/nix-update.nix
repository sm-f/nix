{ ... }:
{
  den.aspects.core = {
    nixos =
      { pkgs, config, ... }:
      let
        user = config.users.users.scott;
        repo = "${user.home}/git/nix";
        cache = "${user.home}/.cache/nix-update-status";

        nix-update-check = pkgs.writeShellApplication {
          name = "nix-update-check";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.diffutils
            pkgs.nix
            pkgs.util-linux
          ];
          text = ''
            readonly LOCK="${repo}/flake.lock"
            readonly CACHE="${cache}"
            tmp=$(mktemp -d)
            trap 'rm -rf "$tmp"' EXIT

            mkdir -p "$(dirname "$CACHE")"
            while true; do
              cp "$LOCK" "$tmp/original.lock"
              cp "$tmp/original.lock" "$tmp/updated.lock"
              nix flake update --flake "${repo}" \
                --output-lock-file "$tmp/updated.lock" --refresh

              # Serialize publication with the path-triggered cache clear.
              exec 9>"$CACHE.lock"
              flock 9
              if ! cmp -s "$LOCK" "$tmp/original.lock"; then
                flock -u 9
                continue
              fi

              if cmp -s "$tmp/original.lock" "$tmp/updated.lock"; then
                rm -f "$CACHE"
              else
                # Publish atomically: starship reads this without the lock.
                printf '' >"$CACHE.tmp"
                mv -f "$CACHE.tmp" "$CACHE"
              fi
              break
            done
          '';
        };
      in
      {
        systemd.timers.nix-update-check = {
          description = "Check for flake updates upstream";
          wantedBy = [ "timers.target" ];
          timerConfig = {
            OnBootSec = "1min";
            OnUnitActiveSec = "30min";
          };
        };

        systemd.services.nix-update-check = {
          description = "Check for flake updates upstream";
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStart = "${nix-update-check}/bin/nix-update-check";
            TimeoutStartSec = "5min";
            Environment = [ "HOME=${user.home}" ];
          };
        };

        systemd.paths.nix-update-lock-changed = {
          description = "Watch for local flake lock updates";
          wantedBy = [ "multi-user.target" ];
          pathConfig.PathChanged = "${repo}/flake.lock";
        };

        systemd.services.nix-update-lock-changed = {
          description = "Clear and refresh flake update status";
          serviceConfig = {
            Type = "oneshot";
            User = user.name;
            ExecStartPost = "+${config.systemd.package}/bin/systemctl start --no-block nix-update-check.service";
          };
          path = [
            pkgs.coreutils
            pkgs.util-linux
          ];
          script = ''
            mkdir -p ${pkgs.lib.escapeShellArg "${user.home}/.cache"}
            exec 9>${pkgs.lib.escapeShellArg "${cache}.lock"}
            flock 9
            rm -f ${pkgs.lib.escapeShellArg cache}
          '';
        };
      };
  };
}
