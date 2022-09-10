{ lib
, stdenv
, fetchFromGitHub

, ski
}:

stdenv.mkDerivation rec {
  pname = "ski-bootloader";
  version = ski.version;

  src = ski.src;

  sourceRoot = "source/ski-bootloader";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/ski/
    install -m0644 ski-bootloader $out/share/ski/

    runHook postInstall
  '';

  meta = ski.meta // {
    description = "vmlinux bootloader for Ski";
    platforms = [ "ia64-linux" ];
  };
}
