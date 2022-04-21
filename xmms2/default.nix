# TODO:
# - sc68, not detected?
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
, fluidsynth
, glib
, libgme
, libmad
, libmodplug
, libogg
, libopus, opusfile
, libpulseaudio
, libsndfile
, libvorbis
, python3Packages
, perl
, pkg-config
, readline
, ruby
, speex
, sqlite
, wafHook, waf
, wavpack
}:

let pypkgs = python3Packages;
in

stdenv.mkDerivation rec {
  pname = "xmms2";
  version = "0.8${suffix}";
  suffix = "pre20201016_8cbeaa18";

  src = fetchFromGitHub {
    owner = "XMMS2";
    repo = "xmms2-devel";
    rev = "8cbeaa1890a08a7d3bfef254a24933f472a1e192";
    sha256 = "sha256-jIu0QDzyVbj6LEYvq8nTcjq5l/Q+vwBCkbNNs2jDX/w=";
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
    libgme
    libogg
    libopus opusfile
    libmad
    libmodplug
    libpulseaudio
    libsndfile
    libvorbis
    readline
    #TODO: plugin path
    #perlPackages.perl
    pypkgs.python
    ruby
    speex
    sqlite
    wavpack
  ];

  nativeBuildInputs = [
    pkg-config
    #TODO: plugin path
    #perlPackages.perl
    (perl.withPackages (ps: [ ps.PodParser ]))
    pypkgs.cython
    pypkgs.python
    wafHook
  ];

  passthru = {
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
