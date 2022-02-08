let
  set_wnoerror = attr: attr.overrideAttrs (oa: {
    CFLAGS   = (oa.CFLAGS   or "") + " -Wno-error=array-bounds";
    CXXFLAGS = (oa.CXXFLAGS or "") + " -Wno-error=array-bounds";
  });
  gen_override = prev: pname: {
    name = pname;
    value = set_wnoerror prev.${pname};
  };
  gen_overrides = prev: pnames: builtins.listToAttrs (builtins.map (gen_override prev) pnames);
in

# generate overrides in form of:
#  { foo = set_wnoerror prev.foo; ... }

final: prev: gen_overrides prev [
  #"criu" # array out of bounds
  #"libbladeRF" # -fcommon
  #"mame" # Waddress: null comparison on non-null array.

  # xorg bug: https://gitlab.freedesktop.org/xorg/xserver/-/issues/1256
  #"xwayland"
]
