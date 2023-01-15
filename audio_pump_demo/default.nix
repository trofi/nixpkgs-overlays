{ lib
, stdenv
, fetchFromGitHub

, SDL2
, pkg-config
, pulseaudio

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "audio_pump_demo";
  version = "unstable-2023-01-09";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = "audio_pump_demo";
    rev = "42836eff80f2e952aef55fd6e60e42b893318873";
    sha256 = "sha256-D7uT4BADVlBmGZmn5V3yqy/nhXV4h16x+EKUIFIcx+o=";
  };

  patches = [ ./0001-makefile-add-trivial-make-install-target.patch ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ SDL2 pulseaudio ];

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
