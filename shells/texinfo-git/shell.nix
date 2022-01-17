{ pkgs ? import <nixpkgs> {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      gnumake
      autoconf
      automake
      coreutils
      gettext
      help2man
      libtool
      ncurses
      perl
    ];

    # hardcodes PATH=... and expects working 'mv'.
    shellHook = ''
      mkj () {
        make -j$(nproc) "$@"
      }

      substituteInPlace texindex/jrtangle \
        --replace "PATH=/bin:" "PATH=${pkgs.coreutils}/bin:/bin:"
    '';
  }
