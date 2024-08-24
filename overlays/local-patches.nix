final: prev: {
  claws-mail = prev.claws-mail.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../claws-mail/show-all-text.patch
    ];
  });

  cvise = prev.cvise.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../cvise/reverse-lines.patch
    ];
  });

  diffoscope = prev.diffoscope.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      # Fix diff on symlinks to directories:
      #   https://salsa.debian.org/reproducible-builds/diffoscope/-/merge_requests/144
      (prev.fetchpatch {
        name = "symlink-dir.patch";
        url = "https://salsa.debian.org/reproducible-builds/diffoscope/-/merge_requests/144.patch";
        hash = "sha256-juLPO67mYFg2vXPF5piR7W2YY2HOuOVAiGpmYwpjTkQ=";
      })
    ];
  });

  nixVersions = prev.nixVersions // {
    unstable = (prev.nixVersions.latest or prev.nixVersions.unstable).overrideAttrs(oa: {
      patches = (oa.patches or []) ++ [
        ../nix/editor-no-nl.patch
      ];
    });
  };

  xwayland = prev.xwayland.override {
    libXfont2 = prev.xorg.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ prev.lib.optionals (oa.version == "2.0.6")  [
        ../libXfont2/nofollow.patch
      ];
    });
  };
}
