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

, withGtk ? true, gnome2

, unstableGitUpdater
, ski
}:

stdenv.mkDerivation rec {
  pname = "ski";
  version = "unstable-2022-09-17";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "e0d7f5c1d2a94dc03c402c7e25a940e75306afd0";
    sha256 = "sha256-kPoeVnxIo7VG5MdUULQIQXftjmbRfzf9oSUGXqNdymE=";
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
  ] ++ lib.optionals withGtk [
    gnome2.libglade
    gnome2.libgnomeui
  ]
  ;

  configureFlags = lib.optionals withGtk [
    "--with-gtk"
  ];

  makeFlags = [
    "appdefaultsdir=${placeholder "out"}/etc/X11/app-defaults"
  ];

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package ski --arg include-overlays true
  passthru = {
    updateScript = unstableGitUpdater {
      url = "https://github.com/trofi/ski.git";
    };
    tests = {
      noGui = ski.override { withGtk = false; };
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
