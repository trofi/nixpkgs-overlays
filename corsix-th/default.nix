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
  version = "unstable-2023-01-31";

  src = fetchFromGitHub {
    owner = "CorsixTH";
    repo = "CorsixTH";
    rev = "b2f11489336764acee2c8fe11b50c0bc11bfe6cc";
    sha256 = "sha256-hetFuNOGCThm2bsY5N88W9I5SzpxETlcZ9cV0/bbayo=";
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

  luaEnvPath = (lua.pkgs.luaLib or lua.pkgs.lib).genLuaPathAbsStr luaEnv;
  luaEnvCPath = (lua.pkgs.luaLib or lua.pkgs.lib).genLuaCPathAbsStr luaEnv;

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
