final: prev: {
   lib = prev.lib // {
     maintainers = prev.lib.maintainers // {
       trofi = {
         name = "Sergei Trofimovich";
         email = "slyich@gmail.com";

         matrix = "@trofi:matrix.org";
         github = "trofi";
         githubId = 226650;
       };
    };
  };

  audio_pump_demo = final.callPackage ../audio_pump_demo {};
  sdl_video_demo = final.callPackage ../sdl_video_demo {};

  corsix-th = final.callPackage ../corsix-th {};

  dwarffs = final.callPackage ../dwarffs {};

  iowatcher = final.callPackage ../iowatcher {};

  libvisual-plugins = final.callPackage ../libvisual-plugins {};

  liferea = prev.liferea.overrideAttrs (oa: rec {
    # Downgrade from -.14.1 until upstream bug is fixed:
    #   https://github.com/lwindolf/liferea/issues/1212
    version = "1.14.0";
    src = prev.fetchurl {
      url = "https://github.com/lwindolf/liferea/releases/download/v${version}/liferea-${version}.tar.bz2";
      sha256 = "sha256-uC3ksJ4nNXBjQYqNOS4qK6aCK6/Wzf27YXHbM73TpdU=";
    };
  });

  multitextor = final.callPackage ../multitextor {};

  seekwatcher = final.callPackage ../seekwatcher {};

  ski = final.callPackage ../ski {};
  ski-bootloader = final.callPackage ../ski-bootloader {};

  uselex = final.callPackage ../uselex {};

  xmms2 = final.callPackage ../xmms2 {};
  xmms2_0_8 = final.callPackage ../xmms2/0.8 {};
}
