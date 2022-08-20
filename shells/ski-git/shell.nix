{ pkgs ? import ~/nm {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      # build deps
      elfutils
      libbfd
      libiberty
      ncurses
      motif
      ## x11
      xorg.libX11
      xorg.libXt
      xorg.libXext
      ## gtk
      gnome2.libglade
      gnome2.libgnomeui

      # maintainer tools
      autoconf
      automake
      bison
      flex
      gperf
      libtool
      pkg-config

      # for release tarballs
      pkgs.lzip
      pkgs.xz
    ];
    shellHook = ''
      mkj() { make -j$(nproc) "$@"; }
      acm() { ./autogen.sh && ./configure && make; }
    '';
  }
