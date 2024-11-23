{ lib
, stdenv
, fetchFromGitHub

, autoconf
, autoconf-archive
, automake
, bison
, flex
, gperf
, libtool
, pkg-config

, elfutils
, libbfd
, libiberty
, ncurses

, unstableGitUpdater
, ski
}:

stdenv.mkDerivation rec {
  pname = "ski";
  version = "1.5.0-unstable-2024-11-23";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "913a4d0a04b868539c8104a1da946185e181e3bc";
    hash = "sha256-OT4Vg0Iwukp2CvfER8fP0g66K1o65NDniYZ9QBrGVUc=";
  };

  postPatch = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoconf
    autoconf-archive
    automake
    bison
    flex
    gperf
    libtool
    pkg-config
  ];

  buildInputs = [
    elfutils
    libbfd
    libiberty
    ncurses
  ];

  makeFlags = [
    "appdefaultsdir=${placeholder "out"}/etc/X11/app-defaults"
  ];

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package ski --arg include-overlays true
  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
      url = "https://github.com/trofi/ski.git";
    };
  };

  meta = with lib; {
    description = "ia64 (Itanium) instruction set simulator.";
    homepage = "https://github.com/trofi/ski";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
