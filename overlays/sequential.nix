let
  set_seq = attr: attr.overrideAttrs (oa: {
    enableParallelBuilding = oa.enableParallelBuilding or false;
  });
  gen_override = prev: pname: { name = pname; value = set_seq prev.${pname}; };
  gen_overrides = prev: pnames: builtins.listToAttrs (builtins.map (gen_override prev) pnames);
in

# generate overrides in form of:
#  { foo = set_seq prev.foo; ... }

final: prev: gen_overrides prev [
  # TODO: fix these upstream
  # TODO: pull some failures from PR and local hacks

  "gnat6" # fails sometimes
  "heimdal" # elusive failure

  #app-indicator.c:45:10: fatal error: application-service-marshal.h: No such file or directory
  #  45 | #include "application-service-marshal.h"
  #compilation terminated.
  #make[2]: *** [Makefile:788: libappindicator3_la-app-indicator.lo] Error 1
  # "libappindicator-gtk3" # headers deps
  # "libappindicator-gtk2" # headers deps

  # uae> make[2]: *** No rule to make target 'build68kc'.  Stop.
  "uae"
]
