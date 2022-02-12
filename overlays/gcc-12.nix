let
  set_fcommon = attr: attr.overrideAttrs (oa: {
    NIX_CFLAGS_COMPILE = (oa.NIX_COMPILE_CFLAGS or "") + " -std=c++14";
  });
  gen_override = prev: pname: {
    name = pname;
    value = set_fcommon prev.${pname};
  };
  gen_overrides = prev: pnames: builtins.listToAttrs (builtins.map (gen_override prev) pnames);
in

# generate overrides in form of:
#  { foo = set_fcommon prev.foo; ... }

final: prev: gen_overrides prev [
  # TODO: fix these upstream

  # the whole file does not quite work, all are commented out

  #"alliance" # c++17 throw()
  #"archiveopteryx" # operator delete
  #"asymptote" # string(null)
  #"aws-sdk-cpp" # sleep_for definition
  #"bazel" # missing numeric_limits
  #"byzanz" # volatile/glib
  #"cbftp" # nlohmann_json string ambig
  #"cgal" # string(null)
  #"chia-plotter" # alignment is invalid
  #"coin" # string(null)
  #"coin3d" # std::string(NULL)
  #"crawl" # std::string(NULL)
  #"csxcad" # string(NULL)
  #"ctl" # istream is not defined, missing header?
  #"cuneiform" ptr >int comparison
  #"deliantra-server" # c++17: throw(), something else
  #"dbus_cplusplus" # operator>> not seen
  #"diopser" # attribute?
  #"dolfin" # numeric_limits
  #"doctest-2.4.6": -Werror: unused-but-set
  #"enblend-enfuse" # throw
  #"eztrace" # string(null)
  #"falcon" # throw() c++17
  #"fast-downward" # numeric_limits
  #"geant4" string(null)
  #"gringo" numeric_limits
  #"grpc" # missing symbols, mysterious
  #"gstreamermm" volatile/werror
  #"heimdal" # incomplete type?
  #"indi-firmware" # ostream includes
  #"ispc" # ambig
  #"jidgo" # byte clash
  #"kldap" # attribute in the middle
  #"kpimtextedit" # attribute in the middle
  #"kodi" # string(NULL)
  #"lean" # json ambiguity on string
  #"libdynd" # -Werror
  #"libechonest" # throw spec
  #"libjson" # throw()
  #"liblastfm" # throw spec
  #"libmemcached" # string(null)
  #"libreoffice" # unknown
  #"libtorrent-rasterbar" # assert, too small buffer
  #"libwebsockets" # -Werror, overfloww
  #"lief" # mising <memory>
  #"lockfile-progs" # "%s" is NULL
  #"log4shib" #throw()
  #"lximage-qt"
  #"messer-slim" # json/string
  #"minetest" # <shared_ptr>
  #"mit-scheme-x11" # array/ptr decls
  #"monero" string(null)
  #"monero-cli" string(null)
  #"ndn-tools" # anbiguous chrono constructor
  #"oatpp" # string(null)
  #"ola" # ambiguous conversion
  #"omsimulator" # missing header
  #"openbabel" # std::string(NULL)
  #"openocd" # -Werror indent
  #"openzwave" # std::string(NULL)
  #"or-tools" # attributes in the middle
  #"partio" # ?
  #"picotoon" # numeric_limis header
  #"pmdk" # param mismatch
  #"pytorch"#builtins
  # qtbase-5.12.10
  # qtdeclarative-5.14.2 # missing imports
  # qtwebengine-5.15 # string(NULL)
  # "root5": null string
  # "root": includes?
  #"restool" # -Werror
  #"ripser" # std::max clash
  #"rpcs3" # gcc-12/-11 libstdc++ linking
  #"rlottie" # <limits>
  #"roboschool" missing string include?
  #"scalapack" # fortran dimensions
  #"scite" # glibatomic/volatile
  #"simgear" string(NULL)
  #"sleuthkit" # string(NULL)
  #"sonic-lineup" # rel_ops missing include?
  #"svxlink" # string(null)
  #"stunt-rally" # std::optional conflict?
  #"tiscamera"
  #"trafficserver" # header fr strlen()
  #"pythonPackages.pyside-shiboken" # string(null)
  #"ucg" # mutex include is missing
  #"uti" # -Werror=nonnull
  #"libfm-qt" # typename missing?
  #"boringssl" # werror on invalid
  #"opencv3" # werror on invalid
  #"uamqp" # array vs ptr Werror
  #"uhd": sleep_for, header?
  #"tracebox": delete[]!
  #"wimboot" # -Werror array subscript
  #"wownero" # string(NULL)
  #"yap" # int/ptr comparison
  #"zeek" # string incluson
  #"zeroc-ice" # string(null)

  # pending upstream merge:
  #"strelka" # <limits>

  # fixed upstream, wait for a release
  #"inkscape" # null string
  #"oprofile" # string(NULL)
  #"gjs" # string(null)
  #"ocl-icd-loader" #  asm something
]
