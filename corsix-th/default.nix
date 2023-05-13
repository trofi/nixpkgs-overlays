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
  version = "unstable-2023-05-07";

  src = fetchFromGitHub {
    owner = "CorsixTH";
    repo = "CorsixTH";
    rev = "8c772e5290b495ae33d40ebef4673640a81b4670";
    sha256 = "sha256-9j4vlNAe9b9u9cQikBLQdZRoHZaUh88gA2Cl9yjpjwE=";
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
    mainProgram = "corsix-th";
  };
}
