{ system ? builtins.currentSystem
, pkgs ? import <nixpkgs> { inherit system; }
}:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    gcc
    ninja
    (python3.withPackages (pps: [ pps.psutil ]))

    # optional library depends
    valgrind valgrind.dev
    libpfm
  ];
}

