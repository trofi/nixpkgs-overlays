final: prev: {
  iowatcher = final.callPackage ../iowatcher {};

  seekwatcher = final.callPackage ../seekwatcher {};

  vcmi = final.libsForQt5.callPackage ../vcmi {
    ffmpeg = final.ffmpeg_4;
  };

  xmms2 = final.callPackage ../xmms2 {};
}
