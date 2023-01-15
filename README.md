# trofi's nixpkgs overlays

This is an overlay on top of
[nixpkgs](https://github.com/NixOS/nixpkgs) for my personal hacks.

These are small tools,ancient games and small patches on top of
existing packages.

It should be safe to use this overlay on a day-to-day basis. No patches
should cause massive rebuilds of unexpected change in behaviour.

# How to use

I personally pull it in directly into `/etc/nixos/configuration.nix`
as:

```nix
{ config, pkgs, ... }:
  # ...
  imports = [
    # ...
    (import ./trofi/nixpkgs-overlays/nixos/modules/dwarffs.nix)
  ];
  nixpkgs.overlays = [
    # ...
    (import ./trofi/nixpkgs-overlays/overlays/local-packages.nix)
    (import ./trofi/nixpkgs-overlays/overlays/local-patches.nix)
  ];
  environment.systemPackages = with pkgs; [
    # ...
    corsix-th
    iowatcher
    multitextor
    seekwatcher
    ski
    uselex
    xmms2
  ];
```

