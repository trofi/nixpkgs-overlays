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
, game-music-emu
, glib
, libao
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
, waf
, wavpack

, xmms2

, unstableGitUpdater
}:

let pypkgs = python3Packages;
in

stdenv.mkDerivation rec {
  pname = "xmms2";
  version = "0.9.4-unstable-2024-10-07";
  # Drop -unstable-.* suffix.
  versionBase = lib.concatStringsSep "." (lib.take 3 (lib.versions.splitVersion version));

  src = fetchFromGitHub {
    owner = "XMMS2";
    repo = "xmms2-devel";
    rev = "231104f63b98846e63b68266dbaabd300c733280";
    hash = "sha256-YiwrvBff8w65Hp7aaCpkE+rhKro/pwB20RY711iuj0k=";
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
    game-music-emu
    glib
    libao
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
    waf.hook
  ];

  wafConfigureFlags = [
    "--with-vis-reference-clients"
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
            url = "https://github.com/xmms2/xmms2-devel/releases/download/${versionBase}/xmms2-${versionBase}.tar.xz";
            hash = "sha256-EAo10kZwBv4YKJiAQ6kgLoBO2LDpQyat3zK7J2RctCo=";
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
