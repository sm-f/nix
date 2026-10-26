{ ... }:
{
  den.aspects.core = {
    nixos =
      { ... }:
      {
        # howdy: IR face auth (Windows Hello-style)
        services.howdy = {
          enable = true;
          control = "sufficient";
        };

        # IR emitter support for howdy
        services.linux-enable-ir-emitter = {
          enable = true;
        };

        # pam_u2f authfile: key handles + EC public keys.
        # Format: user:handle,pubkey,es256,+presence[:handle,...]
        # New host: pamu2fcfg -u scott -n, append after ':'
        environment.etc."u2f_keys".text = ''
          scott:7D/geI2UltKSoL0H4W5jdpuD1zgxa4jRzXk9AZmf64KE17aD31AUnSqS7V89+12S6JeqVFEvF/hB42YmUdlCD0d98EJiT/ky8O2Edfg5q8iH+UsQwwYAHiw/2x+MNsO2s239H3us/YLupiwhWMC8uVPJWoD4R9W9Bnu9dZBbDqOmzR5KgklJXavBfC4Vg7XVLWVtB45ueAES390jE5efFbD5x6fgQV52JPVqzwV/ZiRlJvULNvgD0q9s3e4sqco/,7Rl+R9WoFAfWXi2L0jUR1j6JXczR4/CqI26w4zV04Ym8yOUJ4UJgN49OJ8Wk9JF+KQY/61RkBygH9sA4oTsrVA==,es256,+presence:UGsKXiLDrpTdVdTcFF2WJLtK0Id4wUHHGFgHY0HbS/SDBd4Jpwyx6tsTxm3et94DYKWh8XR9SvfnPXBRstZ1pY2FdrzokxIfkp2HKGBMPISN2GzJFrojcBaSPSPn10BQ1DbaPVxDAqMH6fLIVMb1Lt5dSzT/cOsBep5z2jSYlVH4csqvl6H9hBS3haACXjcI+8eGkUE9ca2cbJlClpHxmgPN+LDRK9DrtTImY9XQFBg5DwU7kunP+sRpkavQAWK+,covbWEk3ofmuD9FRhJGdAHe92hQtpbWjK469jKxiXOIuF3UQnwjAK8EraTLZSv1Aq5vc+0O/87r6LhQwm7B1LA==,es256,+presence:FgDggpQYo+miYpK5a30uU7MxP223+ersuexPOn6jclUh1nMINFG3RNW+oFYTlJ7ZOlSW7ESjd278K0hSB7HeXA==,wzOFnhqJ+8b8r7ykJOQuLqjDLuxFMWCVR81LlU/kh6QpKAX6CW2ywto6/RPBZbdr+Ds9p4EEI+t8+lqc3A90aw==,es256,+presence
        '';

        security.pam = {
          u2f.settings.cue = true;
          u2f.settings.authfile = "/etc/u2f_keys";
          services = {
            login.u2fAuth = true;
            login.enableGnomeKeyring = true;
            sudo.u2fAuth = true;
            su.u2fAuth = true;
            quickshell.u2fAuth = true;
            quickshell.enableGnomeKeyring = true;
          };
        };
      };
  };
}
