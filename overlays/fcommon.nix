let
  set_fcommon = attr: attr.overrideAttrs (oa: {
    NIX_CFLAGS_COMPILE = (oa.NIX_COMPILE_CFLAGS or "") + " -fcommon";
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
  #"alliance"
  #"ber_metaocaml"
  #"bird"
  #"bristol"
  #"brogue"

  #"ccl"
  #"cdesktopenv"
  #"cdpr"
  #"chocolateDoom"
  #"cgminer"

  #"drbd" # needs ocf-resource-agents backport: https://github.com/ClusterLabs/resource-agents/commit/494c98b606db4fa86d67e76c27692648642ebefe.patch
  #"eli"
  #"eukleides"
  #"flasm"

  #"freetalk"
  #"foomatic-filters"
  #"gerbv"
  #"gnupg1orig"
  #"gpg-mdp"

  #"gpredict"
  #"iftop"
  #"intercal"
  #"jamin"
  #"jfsutils"
  #"lcdproc"

  #"libbladeRF"
  #"lighthouse"
  #"libixp_hg"
  #"macopix"
  #"menu-cache"

  #"minicom"
  #"mmh"
  #"ncftp"
  #"nuweb"
  #"openbgpd"

  #"pcsxr"
  #"pipewire_0_2"
  #"quake3e"

  #"rockbox_utility"
  #"sil"
  #"spaceFM"
  #"svnfs"
  #"syslinux"

  #"tinyfugue"
  #"transcode"
  #"uget"
  #"uim"

  #"urbit"
  #"vaapi-intel-hybrid"
  #"warsow-engine"
  #"webalizer"
  #"wiimms-iso-tools"

  #"w_scan"
  #"xe-guest-utilities"
  #"yap"

  # can't express as is
  #"perl5.34.0-Math-Pari"
  #"gimp-plugin-lqr-plugin"
]
