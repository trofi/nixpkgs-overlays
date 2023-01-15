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
  version = "unstable-2023-01-13";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "sdl_video_demo";
    rev = "6cb760b286b808359f65c1c73d8742301138f754";
    sha256 = "sha256-XKTYiEPndBGaE26aZkbcH67YDr0aTtrVbGKdM18Y22A=";
  };

  patches = [ ./0001-Makefile-add-make-install-trivial-target.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL SDL_gfx SDL2 ];

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
