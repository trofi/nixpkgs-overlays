{ lib
, stdenv
, fetchFromGitHub

, pkg-config
, SDL
, SDL_gfx
, SDL2

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "sdl_video_demo";
  version = "0-unstable-2024-10-29";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "sdl_video_demo";
    rev = "5d9dd4b565df4142b3af1cddf9066e26b682d8ff";
    hash = "sha256-T0qLBlh9EBbLV6ktqsL8HExfAH/P2t0c0/HueUUY3Xo=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL_gfx SDL2 ];

  makeFlagsArray = [ "PREFIX=${placeholder "out"}" ];
  enableParallelBuilding = true;

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package sdl_video_demo --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/hartwork/sdl_video_demo.git";
  };

  meta = with lib; {
    description = "SDL video demo";
    homepage = "https://github.com/hartwork/sdl_video_demo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
