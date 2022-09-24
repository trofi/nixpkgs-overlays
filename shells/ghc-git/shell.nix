{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      ghc
      python3
      autoconf
      automake
      perl
      git
      haskellPackages.alex
      haskellPackages.happy
    ];
}
