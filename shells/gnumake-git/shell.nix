{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      gnumake
      autoconf
      automake
      gettext # autopoint
      pkg-config-unwrapped
    ];
  }
