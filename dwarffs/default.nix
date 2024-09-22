{ lib
, stdenv
, fetchFromGitHub

, boost
, fuse
, nixVersions
, nlohmann_json

, unstableGitUpdater
}:

let
  # Does not work against latest `nix`:
  #   https://github.com/edolstra/dwarffs/issues/26
  nix = nixVersions.nix_2_20;
in stdenv.mkDerivation rec {
  pname = "dwarffs";
  version = "2.0.0-unstable-2024-03-27";

  src = fetchFromGitHub {
    owner = "edolstra";
    repo = "dwarffs";
    rev = "6c4a04269ebcf9438447cfd3078a09538043cbb2";
    sha256 = "sha256-c0KbtYwhsk6+5J8VzmaLoF/hj+YxJfmBBG0QQ/1cB54=";
  };

  buildInputs = [ fuse nix nlohmann_json boost ];
  env.NIX_CFLAGS_COMPILE = "-I ${nix.dev}/include/nix -include ${nix.dev}/include/nix/config.h -D_FILE_OFFSET_BITS=64 -DVERSION=\"${version}\"";

  installPhase = ''
    mkdir -p $out/bin $out/lib/systemd/system

    cp dwarffs $out/bin/
    ln -s dwarffs $out/bin/mount.fuse.dwarffs

    cp run-dwarffs.mount run-dwarffs.automount $out/lib/systemd/system/
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
