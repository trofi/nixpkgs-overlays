{ pkgs ? import <nixpkgs> { overlays = [(prev: final: { gcc = prev.gcc11; })]; } }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      curl
      expat
      gettext
      perl
      tcl
    ];
  shellHook = ''
    fixPerl () {
      patchShebangs $(git grep -l /usr/bin/perl)
    }
    mkj () {
      make -j $(nproc) PERL_PATH=${pkgs.perl}/bin/perl "$@"
    }
  '';
}
