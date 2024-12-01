{ lib
, stdenv
, fetchFromGitHub
, fetchpatch

, boost
, fuse
, nixVersions
, nlohmann_json

, unstableGitUpdater
}:

let
  nix = nixVersions.latest;
in stdenv.mkDerivation rec {
  pname = "dwarffs";
  version = "3.0.0-unstable-2024-09-26";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "dwarffs";
    rev = "8198868ec11d8c14f91543df1db7d7242de8c225";
    sha256 = "sha256-aacxGucADmIfuFmSdCS7WrmPXFBhojADmSOHhIiUTKA=";
  };

  patches = [
    # https://github.com/edolstra/dwarffs/pull/30
    (fetchpatch {
      name = "nix-2.25.patch";
      url = "https://github.com/edolstra/dwarffs/pull/30.patch";
      hash = "sha256-1IbOqgdAA43qnqGCeDl13c5BSTjz3HhlMTlzYsEPLj4=";
      includes = [ "dwarffs.cc" ];
    })
  ];

  buildInputs = [ fuse nix nlohmann_json boost ];
  env.NIX_CFLAGS_COMPILE = "-I ${nix.dev}/include/nix -include ${nix.dev}/include/nix/config.h -D_FILE_OFFSET_BITS=64 -DVERSION=\"${version}\"";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/lib/systemd/system

    cp dwarffs $out/bin/
    ln -s dwarffs $out/bin/mount.fuse.dwarffs

    cp run-dwarffs.mount run-dwarffs.automount $out/lib/systemd/system/

    runHook postInstall
  '';

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package dwarffs --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
    url = "https://github.com/edolstra/dwarffs";
  };

  meta = with lib; {
    description = "A filesystem that fetches DWARF debug info from the Internet on demand.";
    homepage = "https://github.com/edolstra/dwarffs";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
