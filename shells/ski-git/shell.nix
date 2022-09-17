{ pkgs ? import ~/nm {} }:
  pkgs.mkShell {
    nativeBuildInputs = with pkgs; [
      # build deps
      elfutils
      libbfd
      libiberty
      ncurses
      ## gtk
      gnome2.libglade
      gnome2.libgnomeui

      # maintainer tools
      autoconf
      autoconf-archive
      automake
      bison
      flex
      gperf
      pkg-config

      # for release tarballs
      pkgs.lzip
      pkgs.xz
    ];
    shellHook = ''
      mkj() { make -j$(nproc) "$@"; }
      acm() { ./autogen.sh && ./configure --with-gtk --enable-werror "$@" && mkj; }
    '';
  }
