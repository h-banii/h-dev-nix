{
  default,

  lib,
  mkShell,

  openssl,
  fontconfig,
  kdePackages,
  alsa-lib,

  zlib,
  libGL,
  udev,
  vulkan-loader,
  libxkbcommon,
  wayland,
  stdenv,
  freetype,
}:
mkShell {
  name = "h-dev-rust-gui";

  inputsFrom = [ default ];
  inherit (default) RUST_SRC_PATH;

  packages = [
    openssl
    fontconfig
    kdePackages.qmake
    alsa-lib
  ];

  LD_LIBRARY_PATH = lib.makeLibraryPath [
    openssl
    fontconfig

    stdenv.cc.cc.lib

    zlib
    libGL
    udev
    vulkan-loader
    libxkbcommon
    wayland
    freetype
  ];
}
