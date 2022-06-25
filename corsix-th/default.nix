{ lib
, stdenv
, fetchFromGitHub

, SDL2
, SDL2_mixer
, cmake
, makeWrapper
, ffmpeg
, freetype
, lua

, unstableGitUpdater
}:

let luaEnv = lua.withPackages(ps: with ps; [ lpeg luafilesystem ]);
in
stdenv.mkDerivation rec {
  pname = "CorsixTH";
  version = "unstable-2022-06-25";

  src = fetchFromGitHub {
    owner = "CorsixTH";
    repo = "CorsixTH";
    rev = "d48258b257fdca6a42b8ae569386efb9460f6799";
    sha256 = "sha256-/XSC1f/NQWqUwRRAXozkk5WBKpFJhcE3HVREJfaBcGM=";
  };

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs = [
    SDL2
    SDL2_mixer
    ffmpeg
    freetype
    luaEnv
  ];

  luaEnvPath = lua.pkgs.lib.genLuaPathAbsStr luaEnv;
  luaEnvCPath = lua.pkgs.lib.genLuaCPathAbsStr luaEnv;

  # the wrapping should go away once lua hook is fixed
  postInstall = ''
    wrapProgram $out/bin/corsix-th \
      --set LUA_PATH "$luaEnvPath" \
      --set LUA_CPATH "$luaEnvCPath"
  '';

  # Update as:
  #    nix-shell ./maintainers/scripts/update.nix --argstr package corsix-th --arg include-overlays true
  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/CorsixTH/CorsixTH.git";
  };

  meta = with lib; {
    description = "open-source clone of Theme Hospital";
    homepage = "http://corsixth.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ trofi ];
    platforms = platforms.linux;
  };
}
