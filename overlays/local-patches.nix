final: prev: {
  claws-mail = prev.claws-mail.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../claws-mail/show-all-text.patch
    ];
  });

  cvise = prev.cvise.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../cvise/reverse-lines.patch

      # Keep locally until it's upstream:
      #   https://github.com/NixOS/nixpkgs/pull/267736
      #
      # Refer to shell via /usr/bin/env:
      #   https://github.com/marxin/cvise/pull/121
      (prev.fetchpatch {
        name = "env-shell.patch";
        url = "https://github.com/marxin/cvise/commit/6a416eb590be978a2ad25c610974fdde84e88651.patch";
        hash = "sha256-Kn6+TXP+wJpMs6jrgsa9OwjXf6vmIgGzny8jg3dfKWA=";
      })
    ];
  });

  libglvnd = prev.libglvnd.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      # Keep locally until it's in `master` of `nixpkgs`:
      #   https://nixpk.gs/pr-tracker.html?pr=267505
      #
      # Enable 64-bit file APIs on 32-bit systems:
      #   https://gitlab.freedesktop.org/glvnd/libglvnd/-/merge_requests/288
      (prev.fetchpatch {
        name = "large-file.patch";
        url = "https://gitlab.freedesktop.org/glvnd/libglvnd/-/commit/956d2d3f531841cabfeddd940be4c48b00c226b4.patch";
        hash = "sha256-Y6YCzd/jZ1VZP9bFlHkHjzSwShXeA7iJWdyfxpgT2l0=";
      })
    ];
  });

  xwayland = prev.xwayland.override {
    libXfont2 = prev.xorg.libXfont2.overrideAttrs (oa: {
      patches = (oa.patches or []) ++ [
        ../libXfont2/nofollow.patch
      ];
    });
  };
}
