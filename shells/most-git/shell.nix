{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      slang
      ncurses
    ];
  shellHook = ''

    sed -i -e "s|-ltermcap|-lncurses|" configure
    sed -i autoconf/Makefile.in src/Makefile.in \
      -e "s|/bin/cp|cp|"  \
      -e "s|/bin/rm|rm|"

    cfg () {
      ./configure --with-slang=${pkgs.slang.dev}
    }
  '';
}
