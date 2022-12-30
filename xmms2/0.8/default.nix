# TODO:
# - sc68, not detected: no sc68-config
# - libofa, do i need it?
# - fftw?
# - jack?
# - boost? (c++ bindings)
# - systemd user unit?

{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, alsa-lib
, avahi-compat
, cunit
, curl
, faad2
, flac
, flex
, fluidsynth
, glib
, libao
, libgme
, libmad
, libmms
, libofa
, libogg
, libopus, opusfile
, libpulseaudio
, libsndfile
, libvisual, SDL
, libvorbis
, mpg123
, python2Packages
, perl
, pkg-config
, readline
, speex
, sqlite
, tremor
, valgrind
, wafHook, waf
, wavpack

, xmms2

, unstableGitUpdater
}:

let pypkgs = python2Packages;
in

stdenv.mkDerivation rec {
  pname = "xmms2";
  version = "0.8DrO_o";

  src = fetchurl {
    url = "mirror://sourceforge/xmms2/xmms2-${version}.tar.bz2";
    hash = "sha256-x35B571XiIidWi94Mxyox0i4chvS5Z82w2rUx8roaUo=";
  };

  buildInputs = [
    alsa-lib
    avahi-compat
    cunit
    curl
    faad2
    flac
    fluidsynth
    glib
    libao
    libgme
    libofa
    libogg
    libopus opusfile
    libmad
    libmms
    libpulseaudio
    libsndfile
    libvisual SDL
    libvorbis
    mpg123
    readline
    perl
    speex
    sqlite
    tremor
    wavpack
  ];

  nativeBuildInputs = [
    flex
    pkg-config
    (perl.withPackages (ps: [ ps.PodParser ]))
    pypkgs.cython
    pypkgs.python
    valgrind
    wafHook
  ];

  wafConfigureFlags = [
    "--without-optionals=python,vistest"
    "--without-plugins=airplay"
    "--with-perl-archdir=${placeholder "out"}/lib/perl5/site_perl/${perl.version}"
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/XMMS2/xmms2-devel.git";
    };

    # for client applications that use python bindings
    python = pypkgs.python;
  };

  meta = with lib; {
    description = "music player daemon";
    homepage = "https://github.com/xmms2/xmms2-devel";
    license = licenses.gpl2;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
