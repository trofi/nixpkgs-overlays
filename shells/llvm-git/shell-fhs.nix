{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { inherit system; }
}:

let e =
  pkgs.buildFHSEnv {
    name = "llvm-git-build-env";
    targetPkgs = ps: with ps; [
      cmake
      gcc
      ninja
      python3

      # optional library depends
      valgrind valgrind.dev
      libpfm
    ];
  };
in e.env
