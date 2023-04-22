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
  version = "unstable-2023-04-18";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "sdl_video_demo";
    rev = "e99acda54d864b594ea3095cbc5c14015d31bc58";
    sha256 = "sha256-xKCBqMBzJ+VsFHhFe/8spHCxg7fWu7ooy4+7cgbxdok=";
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
