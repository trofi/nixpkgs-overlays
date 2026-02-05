{ lib
, stdenv
, fetchurl

, gtk2
, jack1
, libGL
, libvisual
, mesa_glu
, libice
, libx11
, libxt
, libxxf86vm

, bison
, flex
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "libvisual-plugins";
  version = "0.4.1";

  src = fetchurl {
    url = "mirror://sourceforge/libvisual/${pname}-${version}.tar.gz";
    hash = "sha256-gRsa4VfNogxzDeGiySvRMQDKO3dsTnOUrIk0W6vIbSY=";
  };

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
    libice
    libx11
    libxt
    libxxf86vm
  ];

  configureFlags = [
    # needs alsa-0.9
    "--disable-alsa"
    # needs gstreamer-0.8
    "--disable-gstreamer-plugin"
    # don't attempt to write to libvirual's directory
    "--with-plugins-base-dir=${placeholder "out"}/plugins"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "An abstraction library for audio visualisations (plugins)";
    homepage = "https://sourceforge.net/projects/libvisual/";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
  };
}
