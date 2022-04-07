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
, ncurses

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "ski";
  version = "unstable-2021-06-19";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "f210dc0bb07e7a6b1a5039901299e8c24cf37055";
    sha256 = "sha256-f7RnC5G6Mxu8TY3nXxnSfOxWyxTcn853EQxhf5cVZcE=";
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
    ncurses
  ];

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package ski --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/trofi/ski.git";
  };

  meta = with lib; {
    description = "ia64 (Itanium) instruction set simulator.";
    homepage = "https://github.com/trofi/ski";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
