{ pkgs ? import ~/n {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      pkgsCross.ia64.stdenv.cc
    ];
  }
