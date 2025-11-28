{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      autoconf
      automake
      libtool
      texinfo

      boost
    ];

    shellHook = ''
      mkj () {
        make -j$(nproc) "$@"
      }

      cfg() {
          ./configure --with-boost=${pkgs.boost} "$@"
      }
    '';
  }
