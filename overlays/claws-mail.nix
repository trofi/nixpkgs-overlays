final: prev: {
  claws-mail = prev.cvise.overrideAttrs(oa: {
    patches = (oa.patches or []) ++ [
     #../claws-mail/show-all-text.patch
    ];
  });
}
