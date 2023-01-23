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
  version = "unstable-2023-01-16";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "sdl_video_demo";
    rev = "1d7f29d18da4adbf9e44bf5dde8ca6cf6844d375";
    sha256 = "sha256-jbJQ9gznRUVxZwQij6imNrU/EZbTilh9Ceh8C7bPCI0=";
  };

  nativeBuildInputs = [ pkg-config ];
  # TODO: drop SDL2 when https://github.com/NixOS/nixpkgs/pull/211150
  # propagates enough.
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
