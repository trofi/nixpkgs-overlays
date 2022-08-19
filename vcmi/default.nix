{ lib
, mkDerivation
, fetchFromGitHub

, cmake

, SDL2
, SDL2_image
, SDL2_mixer
, SDL2_ttf
, boost
, ffmpeg
, luajit
, minizip
, qtbase
, tbb
, zlib

, unstableGitUpdater
}:

mkDerivation rec {
  pname = "vcmi";
  version = "unstable-2022-08-15";

  src = fetchFromGitHub {
    owner = "vcmi";
    repo = "vcmi";
    rev = "ff00747ecf2d5fe1a2e026483b819d53e3cbfed0";
    sha256 = "sha256-DytM1KnlNaQgi5VN2OVntwPxjtxgNFBqOycAayh9pB0=";
    fetchSubmodules = true;
  };

  patches = [ ./vcmi-SDL2.patch ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_ttf
    boost
    ffmpeg
    luajit
    minizip
    qtbase
    tbb
    zlib
  ];

  cmakeFlags = [
    # Make libvcmi.so discoverable in non-standard location.
    # Default rpath does not contain it at all.
    "-DCMAKE_INSTALL_RPATH=${placeholder "out"}/lib/vcmi"

    "-DENABLE_PCH=OFF"

    # Upstream assumes relative value whilc nixpkgs passes absolute.
    # Both should be allowed:
    #  https://cmake.org/cmake/help/latest/module/GNUInstallDirs.html
    # Meawhile work it around by passing relative value.
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package vcmi --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/vcmi/vcmi.git";
  };

  meta = with lib; {
    description = "open-source engine for Heroes of Might and Magic III";
    homepage = "https://vcmi.eu/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
