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

  corsix-th = final.callPackage ../corsix-th {};

  iowatcher = final.callPackage ../iowatcher {};

  multitextor = final.callPackage ../multitextor {};

  seekwatcher = final.callPackage ../seekwatcher {};

  ski = final.callPackage ../ski {};

  vcmi = final.libsForQt5.callPackage ../vcmi {};

  xmms2 = final.callPackage ../xmms2 {};
}
