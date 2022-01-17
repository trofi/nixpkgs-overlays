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
, fetchpatch
, fetchurl
, alsa-lib
, cunit
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
#, perlPackages
, pkg-config
, readline
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
  suffix = "pre20201016_46da10f0";

  src = fetchFromGitHub {
    owner = "XMMS2";
    repo = "xmms2-devel";
    rev = "46da10f0e20c53fd2b40843617ed182c0cba4ebb";
    sha256 = "sha256-9p0pQBRKztJHrmaqiSw5hSrUB+sxoFiapdW27+l8Dxc=";
    fetchSubmodules = true;
  };

  patches = [
    # Upstream fix for -fno-common failure.
    (fetchpatch {
      name = "s4-gcc-10.patch";
      url = "https://github.com/xmms2/s4/commit/510ab280baffc8ab7ee4b9aa41e96b9713f97e80.patch";
      sha256 = "sha256-M1almvpN6sVc2xAVpRjrfM3i+CgSeBp5ToI+qniwaQ0=";
      stripLen = 1;
      extraPrefix = "src/lib/s4/";
    })

    # Pending fix for optimized builds by default.
    (fetchurl {
      name = "O2-by-default.patch";
      url = "https://patch-diff.githubusercontent.com/raw/xmms2/xmms2-devel/pull/7.patch";
      sha256 = "sha256-MtnxgOEjQB8KhbSver0Qx6YL8fNC56WjCisH5/EyBOA=";
    })

    # Pending fix for deterministic mans.
    (fetchurl {
      name = "deterministic-man.patch";
      url = "https://patch-diff.githubusercontent.com/raw/xmms2/xmms2-devel/pull/8.patch";
      sha256 = "sha256-I42gaM0PpqsuZL1jMuylsM1HkLlf8eCedJu8PsaPjJs=";
    })

    # pendign update to latest waf
    (fetchurl {
      name = "waf-2.patch";
      url = "https://patch-diff.githubusercontent.com/raw/xmms2/xmms2-devel/pull/9.patch";
      sha256 = "sha256-Gf8k+pO307sSj1qod1NUYSKPj39iGpJXxMpLkhvWvug=";
    })
  ];

  buildInputs = [
    alsa-lib
    cunit
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
    #perlPackages.PodParser
    pypkgs.python
    speex
    sqlite
    wavpack
  ];

  nativeBuildInputs = [
    pkg-config
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
    platforms = platforms.linux;
  };
}
