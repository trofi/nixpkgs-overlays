final: prev: {
  checkpatch = final.callPackage ../checkpatch {};

  chessutils = final.callPackage ../chessutils {};

  iowatcher = final.callPackage ../iowatcher {};

  multitextor = final.callPackage ../multitextor {};

  seekwatcher = final.callPackage ../seekwatcher {};

  vcmi = final.libsForQt5.callPackage ../vcmi {
    ffmpeg = final.ffmpeg_4;
  };

  xmms2 = final.callPackage ../xmms2 {};
}
