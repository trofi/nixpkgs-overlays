{ localSystem ? { system = builtins.currentSystem; }
, crossSystem ? localSystem
, pkgs ? import <nixpkgs> (
  { inherit localSystem; } // (if (localSystem == crossSystem) then {} else {
    # TODO: ideally <nixpkgs> should yield the same result if
    # 'crossSystem' is passed explicitly and 'localSystem == crossSystem'
    inherit crossSystem;
  }))
}:

let e =
  pkgs.buildFHSEnv {
    name = "gcc-git-build-env";
    targetPkgs = ps: with ps; [
      # library depends
      gmp gmp.dev
      isl
      libffi libffi.dev
      libmpc
      libxcrypt
      mpfr mpfr.dev
      xz xz.dev
      zlib zlib.dev

      # git checkout need flex as they are not complete release tarballs
      m4
      bison
      flex
      texinfo

      # test harness
      dejagnu
      autogen

      # valgrind annotations
      valgrind valgrind.dev

      # toolchain itself
      gcc
      stdenv.cc
      stdenv.cc.libc stdenv.cc.libc_dev

      # Add /lib/cpp symlink. Used by profiledbootstrap.
      # Can be removed once gcc rebases against autoconf with
      # b560f0a657 "AC_PROG_*CPP: Try ‘cpp’ before ‘/lib/cpp’" fix
      # which is in 2.70 and later.
      (pkgs.runCommand "mk-lib-cpp" {} ''
        mkdir -p $out/lib
        ln -s ${stdenv.cc}/bin/cpp $out/lib/
      '')
    ];
  };
in e.env
