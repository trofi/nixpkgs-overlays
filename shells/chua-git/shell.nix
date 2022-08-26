# enter as:
# $ nix develop --impure --expr 'with import ~/n {}; gcc.cc'
# Can't get fully built, but xg++ is there

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    freeglut
    libglvnd
    mesa_glu
    pkg-config
  ];
}
