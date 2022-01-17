# enter as:
# $ nix develop --impure --expr 'with import ~/n {}; gcc.cc'
# Can't get fully built, but xg++ is there

{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    gmp
    mpfr
    libmpc

    # git checkout need flex as they are not complete release tarballs
    flex

    # test harness
    dejagnu
  ];

  # TODO: why? libgcc.so breakage?
  hardeningDisable = [ "format" "pie" ];

  shellHook = ''
    rm -rfv __td__
    mkdir -p __td__
    ln -vsf ${pkgs.lib.getDev pkgs.stdenv.cc.libc}/include __td__/include
    ln -vsf ${pkgs.stdenv.cc.libc}/lib __td__/lib
    ln -vsf . __td__/x86_64-pc-linux-gnu

    cfg() {
       COMMON_FLAGS=(
         # speed up build
         -O1
         # detailed debugging
         -ggdb3
       )
       args=(
         # enabled by default, NixOS has no multilib binaries
         --disable-multilib

         # avoid intermediate rebuild, does not work without crt
         --disable-bootstrap

         --with-native-system-header-dir=${pkgs.lib.getDev pkgs.stdenv.cc.libc}/include
         --prefix=''${PWD}/__td__

         # -O1 to speed up build
         # -B to pull in crt files
         CFLAGS="''${COMMON_FLAGS[*]}"
         CXXFLAGS="''${COMMON_FLAGS[*]}"
         LDFLAGS="''${COMMON_FLAGS[*]}"
       )
       ~/dev/git/gcc/configure "''${args[@]}"
    }
  '';
}
