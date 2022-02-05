final: prev: {
  vcmi = final.libsForQt5.callPackage ../vcmi {
    ffmpeg = final.ffmpeg_4;
  };
}
