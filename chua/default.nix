{ lib
, stdenv
, fetchFromGitHub

, meson
, ninja
, pkg-config

, freeglut
, libGL
, libGLU

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "chua";
  version = "0-unstable-2024-12-04";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "chua";
    rev = "3400b62494d51bffe9acee98f623e3a40084ecfd";
    hash = "sha256-VuMF50vH494QdARAF29/RDkwYs4TZyJfVBgqxUUhec4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    freeglut
    libGL
    libGLU
  ];

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr chua --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/trofi/chua.git";
  };

  meta = with lib; {
    description = "Chua strange attractor render";
    homepage = "https://github.com/trofi/chua";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
