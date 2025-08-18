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
  version = "0-unstable-2025-08-12";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "sdl_video_demo";
    rev = "03994b18ea1419c4521699ba1ed9630ba5147e0f";
    hash = "sha256-wrmOjbi58nvZ/W2kQoCevWEVNa0urpTD03hRpVaymyY=";
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
