# Attributes one can ignore when traversing <nixpkgs> attribute tree.
#
# The constant list is inspired by pkgs/top-level/release-attrpaths-superset.nix
# but is not a strict copy of it:
#   there are knobs to traverse more package sets to increase the span.
{ lib
, ignoreCross ? true
}:
{
  topLevel = [

  ] ++ lib.optionals ignoreCross [
    # Has many targets, significantly increases RAM usage.
    "pkgsCross"
  ];

  anyLevel = [
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

    # workaroound: fails eval
    "swiftPackages"
  ];
}
