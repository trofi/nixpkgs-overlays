{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      gmp
      mpfr
      libmpc

      # snapshots need flex as they are not complete release tarballs
      flex
    ];
    hardeningDisable = [ "format" "pie" ];
  }
