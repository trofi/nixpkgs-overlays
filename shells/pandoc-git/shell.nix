{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    ghc
    cabal-install

    pkg-config
    zlib
  ];
}
