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

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "ski";
  version = "unstable-2022-07-07";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "ski";
    rev = "568efd789fab1f932aa926b1db86dcb75e9c115c";
    sha256 = "sha256-dwHccL89bXzsjDr8O1DmVHlBQQ6aHgNLEaHJCJqHG9w=";
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
