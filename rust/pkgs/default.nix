{
  pkgs,
  flake-inputs,
  h-lib,
  ...
}:
pkgs.lib.makeScope pkgs.newScope (self: {
  inherit flake-inputs h-lib;
  buildBevyPackage = self.callPackage ./build-bevy-package.nix { };
  buildRustDocs = self.callPackage ./build-rust-docs.nix { };
  buildRustPackage = self.callPackage ./build-rust-package.nix { };
  wrapVulkanLoader = self.callPackage ./wrap-vulkan-loader.nix { };
})
