{ lib
, stdenv
, fetchFromGitHub

, autoconf
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

, withX11 ? true, motif, xorg
, withGtk ? true, gnome2

, unstableGitUpdater
, ski
}:

stdenv.mkDerivation rec {
  pname = "ski";
  version = "unstable-2022-08-20";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "a41b8e63ff69a68fb5907a7a2a3a01cfdb94ef31";
    sha256 = "sha256-fxm/XNxzCeYdszRBWWbbYH6gVog5LmROKxUFGba957A=";
  };

  postPatch = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [
    autoconf
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
  ] ++ lib.optionals withX11 [
    motif
    xorg.libX11
    xorg.libXt
    xorg.libXext
  ] ++ lib.optionals withGtk [
    gnome2.libglade
    gnome2.libgnomeui
  ]
  ;

  configureFlags = lib.optionals withX11 [
    "--with-x11"
  ] ++ lib.optionals withGtk [
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
      noGui = ski.override { withX11 = false; withGtk = false; };
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
