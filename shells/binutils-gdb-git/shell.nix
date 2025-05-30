{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      bison
      flex

      gmp
      mpfr
    ];
}
