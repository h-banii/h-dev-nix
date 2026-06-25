{ pkgs, ... }:
let
  rootShell =
    { mkShell, pkgs }:
    mkShell {
      name = "h-dev-rust";
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      nativeBuildInputs = with pkgs; [
        cargo
        rustc
        rustfmt

        rust-analyzer
        clippy

        pkg-config
        clang
        wild-unwrapped

        cargo-audit
      ];
    };
in
pkgs.lib.makeScope pkgs.newScope (self: {
  default = self.callPackage rootShell { };
  rustGuiShell = self.callPackage ./gui.nix { };
  rustGtkShell = self.callPackage ./gtk.nix { };
})
