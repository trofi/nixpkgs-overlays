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
    # Disable known broken less-exercised python atrributes:
    #     https://github.com/NixOS/nixpkgs/issues/340183
    "pypy27Packages"
    "pypy2Packages"
    "pypyPackages"

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

    # causes derivation evalutaion, not usually needed if we traverse
    # every other attribute.
    "drvPath"
    "outPath"

    # vmTools.diskImages has import-from-derivation, an example is
    #     vmTools.diskImages.centos6i386.rpms
    # Let's narrow it down to the failing attributes.
    "centos6i386"
  ] ++ lib.optionals (!ignoreDrvAttrs) [
    # Shared and very heavy implementation detail of nixosTests.
    "driver"
    "driverInteractive"
  ];
}
