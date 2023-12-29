# Attributes one can ignore when traversing <nixpkgs> attribute tree.
#
# The constant list is inspired by pkgs/top-level/release-attrpaths-superset.nix
# but is not a strict copy of it:
#   there are knobs to traverse more package sets to increase the span.
{ lib
, ignoreCross ? true
, ignoreDrvAttrs ? true
}:
{
  topLevel = [
    # workaroound: fails eval
    "swiftPackages"

  ] ++ lib.optionals ignoreCross [
    # Has many targets, significantly increases RAM usage.
    "pkgsCross"
  ] ++ lib.optionals (!ignoreDrvAttrs) [
    # Each test is very heavy.
    "nixosTests"
  ];

  anyLevel = [
    # Usually contains full package set most of which are not used for
    # bootstrap.
    "__bootPackages"

    # internal implementation of package sets, never needs explicit
    # traversal:
    "__splicedPackages"
    # Cross-compilation attributes. Migh be generally useful, but
    # usually pkgsCross.* references provide very good coverage.
    "pkgsBuildBuild"
    "pkgsBuildHost"
    "pkgsBuildTarget"
    "pkgsHostHost"
    "pkgsHostTarget"
    "pkgsTargetTarget"
    "buildPackages"
    "targetPackages"

    # An alias to the whole package set
    "gitAndTools"

    # Top-level attribute, frequently re-spelled.
    "pkgs"

    # Avoid explosion like pkgsLLVM.pkgsCross, pkgsCross.pkgsLLVM
    "pkgsLLVM"
    "pkgsMusl"
    "pkgsStatic"
    "pkgsCross"
    "pkgsi686Linux"

    # workarounds: gemType is somehow null all the time
    "gemType"

    # causes derivation evalutaion, not usually needed if we traverse
    # every other attribute.
    "drvPath"
    "outPath"
  ];
}
