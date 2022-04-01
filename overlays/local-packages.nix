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

  checkpatch = final.callPackage ../checkpatch {};

  chessutils = final.callPackage ../chessutils {};

  iowatcher = final.callPackage ../iowatcher {};

  multitextor = final.callPackage ../multitextor {};

  seekwatcher = final.callPackage ../seekwatcher {};

  vcmi = final.libsForQt5.callPackage ../vcmi {};

  xmms2 = final.callPackage ../xmms2 {};
}
