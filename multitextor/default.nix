{ lib
, stdenv
, fetchFromGitHub
, cmake
, gpm
, ncurses

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "multitextor";
  version = "unstable-2022-08-07";

  src = fetchFromGitHub {
    owner = "vikonix";
    repo = "multitextor";
    rev = "c97233c3100f27f4cac3a76b7cdc3163f44c0eb8";
    sha256 = "sha256-5evng3gJoycE5P0rRX/ziiPtzw9D42aMCCaiW7YwWgs=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    gpm
    ncurses
  ];

  enableParallelBuilding = true;

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package multitextor --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/vikonix/multitextor";
  };

  meta = with lib; {
    description = "Multiplatform command line text editor.";
    homepage = "https://github.com/vikonix/multitextor";
    license = licenses.bsd2;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
