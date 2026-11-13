{ inputs, lib, ... }:
{
  imports = [ inputs.den.flakeModule ];
  _module.args.utils = import ../utils;

  den.schema.user.classes = lib.mkDefault [ "hjem" ];

  den.hosts.x86_64-linux.eris = {
    users.scott = {
      settings.git = {
        name = "Scott McKendry";
        email = "me@scottmckendry.tech";
      };
    };

    settings = {
      fleet = {
        primaryUser = "scott";
        repoRoot = "/home/scott/git/nix";
        cachix = {
          name = "scottmckendry";
          publicKey = "scottmckendry.cachix.org-1:jB2i6xNpH0TiZfTe2p3VfIejB3nUT8bf7PYsn9uOV3I=";
        };
      };

      locale = {
        default = "en_NZ.UTF-8";
        supported = [
          "en_NZ.UTF-8/UTF-8"
          "en_GB.UTF-8/UTF-8"
        ];
      };

      swap = {
        size = 32 * 1024;
        resumeOffset = 14282244;
      };

      luks.devices = [ "luks-0074ecff-31d1-498a-9571-b38b8b85a1fd" ];

      security.u2fKeys.scott = "7D/geI2UltKSoL0H4W5jdpuD1zgxa4jRzXk9AZmf64KE17aD31AUnSqS7V89+12S6JeqVFEvF/hB42YmUdlCD0d98EJiT/ky8O2Edfg5q8iH+UsQwwYAHiw/2x+MNsO2s239H3us/YLupiwhWMC8uVPJWoD4R9W9Bnu9dZBbDqOmzR5KgklJXavBfC4Vg7XVLWVtB45ueAES390jE5efFbD5x6fgQV52JPVqzwV/ZiRlJvULNvgD0q9s3e4sqco/,7Rl+R9WoFAfWXi2L0jUR1j6JXczR4/CqI26w4zV04Ym8yOUJ4UJgN49OJ8Wk9JF+KQY/61RkBygH9sA4oTsrVA==,es256,+presence:UGsKXiLDrpTdVdTcFF2WJLtK0Id4wUHHGFgHY0HbS/SDBd4Jpwyx6tsTxm3et94DYKWh8XR9SvfnPXBRstZ1pY2FdrzokxIfkp2HKGBMPISN2GzJFrojcBaSPSPn10BQ1DbaPVxDAqMH6fLIVMb1Lt5dSzT/cOsBep5z2jSYlVH4csqvl6H9hBS3haACXjcI+8eGkUE9ca2cbJlClpHxmgPN+LDRK9DrtTImY9XQFBg5DwU7kunP+sRpkavQAWK+,covbWEk3ofmuD9FRhJGdAHe92hQtpbWjK469jKxiXOIuF3UQnwjAK8EraTLZSv1Aq5vc+0O/87r6LhQwm7B1LA==,es256,+presence:FgDggpQYo+miYpK5a30uU7MxP223+ersuexPOn6jclUh1nMINFG3RNW+oFYTlJ7ZOlSW7ESjd278K0hSB7HeXA==,wzOFnhqJ+8b8r7ykJOQuLqjDLuxFMWCVR81LlU/kh6QpKAX6CW2ywto6/RPBZbdr+Ds9p4EEI+t8+lqc3A90aw==,es256,+presence";
    };
  };
}
