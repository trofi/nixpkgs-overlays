{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake
      bison
      cmake
      gbenchmark
      git
      libtool
      python3
    ];
}
