{ pkgs ? import <nixpkgs> {} }:

let e =
  pkgs.buildFHSEnv {
    name = "re2c-ghpages-build-env";
    targetPkgs = ps: with ps; [
      # tools
      cmake
      git
      ninja
      python3

      # libraries
      zlib
    ];

    profile = ''
      # fix SSL certs
      export NIX_SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    '';
  };
in e.env
