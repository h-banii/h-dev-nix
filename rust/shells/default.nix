{ pkgs, ... }:
pkgs.lib.makeScope pkgs.newScope (self: {
  rust-shell = self.callPackage ./rust-shell.nix { };
  rust-gui-shell = self.callPackage ./rust-gui-shell.nix { };
  rust-gtk-shell = self.callPackage ./rust-gtk-shell.nix { };
})
