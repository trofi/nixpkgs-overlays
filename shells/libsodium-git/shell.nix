{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake
      libtool
      util-linux # getopt
    ];
}
