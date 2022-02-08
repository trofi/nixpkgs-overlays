let
  set_wnoerror = attr: attr.overrideAttrs (oa: {
    CFLAGS   = (oa.CFLAGS   or "") + " -Wno-error";
    CXXFLAGS = (oa.CXXFLAGS or "") + " -Wno-error";
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
  # TODO: fix these upstream

  #"boringssl" # ptr/array decl mismatch
  #"gnuapl" # nonnull
  #"mitscheme" # ptr/array decl mismatch
  #"mstflint" # -Werror=fall-through
]
