{ lib
, stdenv
, fetchFromGitHub

, ruby_3_1
, binutils-unwrapped-all-targets

, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "uselex";
  version = "0.0.1-unstable-2023-09-22";

  src = fetchFromGitHub {
    owner = "trofi";
    repo = "uselex";
    rev = "ad75f2c87355c89ecd4053d87ca2f4a7eff151cb";
    hash = "sha256-QNC+ieGhS0Wu0t9s2dxagmx5LT0PtVW779qU+l11AVA=";
  };

  buildInputs = [ ruby_3_1 ];

  postPatch = ''
    patchShebangs

    substituteInPlace uselex.rb --replace "'nm'" "'${binutils-unwrapped-all-targets}/bin/nm'"
  '';

  installPhase = ''
    install -d $out/bin
    install -m 0755 uselex.rb $out/bin
  '';

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package uselex --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    url = "https://github.com/trofi/uselex";
  };

  meta = with lib; {
    description = "Look for USEless EXports in object files.";
    homepage = "https://github.com/trofi/uselex";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.all;
    mainProgram = "uselex.rb";
  };
}
