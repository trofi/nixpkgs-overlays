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
  version = "unstable-2022-04-22";

  src = fetchFromGitHub {
    owner = "vikonix";
    repo = "multitextor";
    rev = "76e40d0ec0c19abbe601adcb321a67271b105bf5";
    sha256 = "sha256-d01jJOdMPvQBLYw6Ihb7cfEcDGCWE1lJjo4dYzAOres=";
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
