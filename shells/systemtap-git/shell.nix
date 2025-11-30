{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      dejagnu
      gettext
      (pkgs.python3.withPackages (ps: with ps; [
        setuptools
      ]))

      elfutils
      boost
    ];
  }
