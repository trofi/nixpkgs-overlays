{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      gnumake
      autoconf
      automake
      libtool

      bison
      texinfo
    ];
  }
