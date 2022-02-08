final: prev: {
  nixUnstable = prev.nixUnstable.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
      ../nix/swallow-exceptions.patch
    ];
  });
}
