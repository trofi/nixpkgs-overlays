{ pkgs ? import <nixpkgs> {} }:

let e =
  pkgs.buildFHSEnv {
    name = "live555-build-env";
    targetPkgs = ps: with ps; [
      stdenv.cc

      openssl.out
      openssl.dev
      openssl.bin
    ];
  };
in e.env
