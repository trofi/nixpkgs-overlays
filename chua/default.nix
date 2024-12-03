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
  version = "0-unstable-2024-11-27";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "chua";
    rev = "f2bd7c4b8d785243fbfe9a9ccd8f9e90818e726d";
    hash = "sha256-v9BDmL8WGuBnUZ6BcS4DBvETowd9ww/Nd5mEKTr4fL0=";
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
