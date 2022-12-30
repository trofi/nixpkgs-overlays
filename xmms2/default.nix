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
, ffmpeg
, flex
, fluidsynth
, glib
, libao
, libgme
, libmad
, libmms
, libmodplug
, libofa
, libogg
, libopus, opusfile
, libpulseaudio
, libsndfile
, libvisual, SDL
, libvorbis
, mpg123
, python3Packages
, perl
, pkg-config
, readline
, ruby
, speex
, sqlite
, tremor
, valgrind
, wafHook, waf
, wavpack

, xmms2

, unstableGitUpdater
}:

let pypkgs = python3Packages;
in

stdenv.mkDerivation rec {
  pname = "xmms2";
  version = "unstable-2022-12-30";

  src = fetchFromGitHub {
    owner = "XMMS2";
    repo = "xmms2-devel";
    rev = "39d31d4a7ae463f3df7a09915fe61e2574f4d95f";
    sha256 = "sha256-WKNM4sWEUPRX/pPnUxvkjRyqA471PiXf+tsZ9I917OQ=";
    fetchSubmodules = true;
  };

  buildInputs = [
    alsa-lib
    avahi-compat
    cunit
    curl
    faad2
    ffmpeg
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
    libmodplug
    libpulseaudio
    libsndfile
    libvisual SDL
    libvorbis
    mpg123
    readline
    perl
    pypkgs.python
    ruby
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
    "--with-perl-archdir=${placeholder "out"}/lib/perl5/site_perl/${perl.version}"
    "--with-ruby-archdir=${placeholder "out"}/lib/ruby/site_ruby/${ruby.version.libDir}/${stdenv.hostPlatform.system}"
    "--with-ruby-libdir=${placeholder "out"}/lib/ruby/site_ruby/${ruby.version.libDir}/${stdenv.hostPlatform.system}"
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/XMMS2/xmms2-devel.git";
    };

    # for client applications that use python bindings
    python = pypkgs.python;
    tests = {
        xmms2_release = xmms2.overrideAttrs (oa: {
          src = fetchurl {
            url = "https://github.com/xmms2/xmms2-devel/releases/download/${version}/xmms2-${version}.tar.bz2";
            hash = "sha256-O52Zvl2+fSxDTEsnzXwcw8PddUSmc3BcPwZ0s0jrKKM=";
          };
        });
    };
  };

  meta = with lib; {
    description = "music player daemon";
    homepage = "https://github.com/xmms2/xmms2-devel";
    license = licenses.gpl2;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
