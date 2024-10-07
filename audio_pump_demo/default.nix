{ lib
, stdenv
, fetchFromGitHub

, SDL2
, pkg-config
, portaudio
, pulseaudio

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "audio_pump_demo";
  version = "0-unstable-2024-10-02";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "audio_pump_demo";
    rev = "351532b767a1b45a80f35bad35a95c5f97585ea5";
    hash = "sha256-STME7ahVQ6tgDIZp4CtvL1WktpUXc2T9eRdlK2P6gyA=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL2 portaudio pulseaudio ];

  makeFlagsArray = [ "PREFIX=${placeholder "out"}" ];
  enableParallelBuilding = true;

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package audio_pump_demo --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/hartwork/audio_pump_demo.git";
  };

  meta = with lib; {
    description = "Audio pump demo";
    homepage = "https://github.com/hartwork/audio_pump_demo";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
