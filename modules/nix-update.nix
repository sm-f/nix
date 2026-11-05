{ ... }:
{
  den.aspects.core = {
    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        user = config.users.users.scott;
        repo = "${user.home}/git/nix";
        cacheDir = "${user.home}/.cache";
        statusFile = "${cacheDir}/nix-update-status";
        lockFile = "${statusFile}.lock";
        indicator = "";

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
            readonly STATUS="${statusFile}"
            tmp=$(mktemp -d)
            trap 'rm -rf "$tmp"' EXIT

            mkdir -p "$(dirname "$STATUS")"
            while true; do
              cp "$LOCK" "$tmp/original.lock"
              cp "$tmp/original.lock" "$tmp/updated.lock"
              nix flake update --flake "${repo}" \
                --output-lock-file "$tmp/updated.lock" --refresh

              # Serialize publication with the path-triggered cache clear.
              exec 9>"$STATUS.lock"
              flock 9
              if ! cmp -s "$LOCK" "$tmp/original.lock"; then
                flock -u 9
                continue
              fi

              if cmp -s "$tmp/original.lock" "$tmp/updated.lock"; then
                rm -f "$STATUS"
              else
                # Publish atomically: starship reads this without the lock. Write
                # the glyph too so older configs that cat the file still work.
                printf '%s' ${lib.escapeShellArg indicator} >"$STATUS.tmp"
                mv -f "$STATUS.tmp" "$STATUS"
              fi
              break
            done
          '';
        };
      in
      {
        programs.starship.settings.custom.nix = {
          when = "test -e ${lib.escapeShellArg statusFile}";
          symbol = indicator;
          style = "bold yellow";
          format = "[$symbol]($style) ";
        };

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
            mkdir -p ${lib.escapeShellArg cacheDir}
            exec 9>${lib.escapeShellArg lockFile}
            flock 9
            rm -f ${lib.escapeShellArg statusFile}
          '';
        };
      };
  };
}
