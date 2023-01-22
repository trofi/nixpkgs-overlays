{ lib
, stdenv
, fetchurl

, gtk2
, jack1
, libGL
, libvisual
, mesa_glu
, xorg

, bison
, flex
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libvisual-plugins";
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/libvisual/${pname}-${version}.tar.gz";
    hash = "sha256-i3g6ER1UuSUCCFGZw1GXnQRSuVD83d3R6uKKFthQjps=";
  };

  patches = [
    ./inline-clobber.patch
    ./inline.patch
  ];

  nativeBuildInputs = [
    bison
    flex
    pkg-config
  ];

  buildInputs = [
    gtk2
    jack1
    libGL
    libvisual
    mesa_glu
    xorg.libICE
    xorg.libX11
    xorg.libXxf86vm
    xorg.libXt
  ];

  configureFlags = [
    # leeds alsa-0.9
    "--disable-alsa"
    # needs gstreamer-0.8
    "--disable-gstreamer-plugin"
    # don't attempt to write to libvirual's directory
    "--with-plugins-base-dir=${placeholder "out"}/plugins"
  ];

  NIX_CFLAGS_COMPILE = [ "-fcommon" ];

  NIX_LDFLAGS = [
    "-lm"
    "-lGL"
    "-lGLU"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "An abstraction library for audio visualisations (plugins)";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
