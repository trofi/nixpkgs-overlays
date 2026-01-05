{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake

      ncurses
    ];
  }
