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

  #alliance-unstable> vmcasmld.c:26:10: fatal error: drucompi_y.h: No such file or directory
  "alliance"

  "ats2" # make[2]: *** No rule to make target 'patscc.dats', needed by 'patscc_dats.c'.  Stop.

  # early failure, possibly missing imake dep
  # bash: line 1: ./config/imake/imake: No such file or directory
  # Failed to build upstream version.
  "cdesktopenv"

  "deadpixi-sam" # mysterious build failures

  "gnat6" # fails sometimes

  "heimdal" # elusive failure

  #make[3]: *** No rule to make target '../util/libfaxutil.so.7.0.4', needed by 'faxmsg'.  Stop.
  "hylafaxplus" # parallel make

  "lazarus-qt"

  "libappindicator-gtk3" # headers deps
  "libappindicator-gtk2" # headers deps

  "libf2c" # headers deps?

  "mlkit"
  "mlton20130715"
  "mltonHEAD"

  "munin" # lacks parallel support in makefile, fails instantly

  "netboot" # libtool uses incomplete files?

  "patchutils" # parallel tests fail, file collision

  # Fatal error: can't create obj/ProcDumpTestApplication.o: No such file or directory
  "procdump"

  #"ocaml-mysql" # parallel build failure

  #lwe/iwlib.h:61:10: fatal error: wireless.h: No such file or directory
  "reaverwps"

  #"camlzip"
  #"scsh" # file access, serial?
  #"satallax"

  "tomboy" # config

  # uae> make[2]: *** No rule to make target 'build68kc'.  Stop.
  "uae"

  #dispatch_key.c:25:10: fatal error: compute_crc32.h: No such file or directory
  #  25 | #include "compute_crc32.h"
  #"perl5.34.0-Cache-Memcached-Fast"

  #> Can't write-open blib/man5/razor-agent.conf.5: No such file or directory
  #"perl5.34.0-Razor2-Client-Agent"

  #ocaml-ng.ocamlPackages_4_12.stdcompat
  #ocamlPackages.camlidl
  #ocamlPackages_4_03.camlp4

  #postgresqlPackages.repmgr

  # sent upstream:
  #"ipvsadm"
]
