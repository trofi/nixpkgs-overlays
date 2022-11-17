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
    autogen
  ];

  # TODO: why? libgcc.so breakage?
  hardeningDisable = [ "format" "pie" ];

  shellHook = ''
    rm -rfv __td__
    mkdir -p __td__
    ln -vsf ${pkgs.lib.getDev pkgs.stdenv.cc.libc}/include __td__/include
    ln -vsf ${pkgs.stdenv.cc.libc}/lib __td__/lib
    # for --bootstrap
    ln -vsf ${pkgs.stdenv.cc.libc}/lib __td__/bin
    ln -vsf . __td__/${pkgs.stdenv.hostPlatform.config}

    cat >__td__/local.spec <<-EOF
    *link:
    + %{!shared:%{!static:%{!static-pie:-dynamic-linker ${pkgs.glibc}/lib/ld-linux-x86-64.so.2}}}
    EOF

    cfg() {
       COMMON_FLAGS=(
         # speed up build
         -O1
         # detailed debugging
         -g0
       )
       args=(
         --build=${pkgs.stdenv.buildPlatform.config}
         --host=${pkgs.stdenv.hostPlatform.config}
         --target=${pkgs.stdenv.targetPlatform.config}

         # enabled by default, NixOS has no multilib binaries
         --disable-multilib

         # avoid intermediate rebuild, does not work without crt
         --disable-bootstrap

         # avoid libxcrypt depend
         --disable-libsanitizer

         --with-specs="-specs=$PWD/__td__/local.spec"

         --with-native-system-header-dir=${pkgs.lib.getDev pkgs.stdenv.cc.libc}/include

         --with-gmp-include=${pkgs.gmp.dev}/include
         --with-gmp-lib=${pkgs.gmp.out}/lib
         --with-mpfr-include=${pkgs.mpfr.dev}/include
         --with-mpfr-lib=${pkgs.mpfr.out}/lib
         --with-mpc=${pkgs.libmpc}

         --prefix=''${PWD}/__td__

         # -O1 to speed up build
         # -B to pull in crt files
         CFLAGS="''${COMMON_FLAGS[*]}"
         CXXFLAGS="''${COMMON_FLAGS[*]}"
         LDFLAGS="''${COMMON_FLAGS[*]}"
       )
       ~/dev/git/gcc/configure "''${args[@]}" "$@"
    }
  '';
}
