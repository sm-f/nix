{ ... }:
{
  den.aspects.intune = {
    nixos =
      { pkgs, config, ... }:
      let
        pwquality = unixRule: {
          control = "requisite";
          modulePath = "${pkgs.libpwquality}/lib/security/pam_pwquality.so";
          order = unixRule.order - 50;
          settings = {
            minlen = 16;
            dcredit = -1; # at least 1 digit
            ucredit = -1; # at least 1 uppercase
            lcredit = -1; # at least 1 lowercase
            ocredit = -1; # at least 1 symbol
          };
        };

        # WebKitGTK renders the sign-in webviews blank with the DMABUF and
        # accelerated compositing paths here.
        webkitEnv = {
          WEBKIT_DISABLE_DMABUF_RENDERER = "1";
          WEBKIT_DISABLE_COMPOSITING_MODE = "1";
        };
        webkitArgs = pkgs.lib.concatStringsSep " " (
          pkgs.lib.mapAttrsToList (name: value: "--set ${name} ${value}") webkitEnv
        );
      in
      {
        services.intune.enable = true;

        # Upstream installs these units but leaves them disabled.
        systemd.sockets.intune-daemon.wantedBy = [ "sockets.target" ];
        systemd.user.timers.intune-agent.wantedBy = [ "graphical-session.target" ];

        # intune-portal uses WebKitGTK -> libsoup, which needs the GIO TLS module.
        services.gnome.glib-networking.enable = true;

        environment.sessionVariables = webkitEnv // {
          SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
        };

        # D-Bus activation does not inherit the package-specific Wayland/WebKit
        # env, so bake it into the broker binary.
        nixpkgs.overlays = [
          (final: prev: {
            microsoft-identity-broker = prev.microsoft-identity-broker.overrideAttrs (old: {
              nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.makeWrapper ];
              postInstall = (old.postInstall or "") + ''
                wrapProgram $out/bin/microsoft-identity-broker \
                  --set GDK_BACKEND wayland \
                  ${webkitArgs}
              '';
            });
          })
        ];

        # Intune only inspects common-password, system-password, and password-auth.
        # NixOS applies password rules via passwd, so mirror them there too.
        security.pam.services = {
          passwd.rules.password.pwquality = pwquality config.security.pam.services.passwd.rules.password.unix;
          "common-password".rules.password.pwquality =
            pwquality
              config.security.pam.services."common-password".rules.password.unix;
        };
      };
  };
}
