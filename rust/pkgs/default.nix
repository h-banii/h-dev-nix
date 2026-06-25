{
  pkgs,
  craneLib,
  h-lib,
  ...
}:
pkgs.lib.makeScope pkgs.newScope (self: {
  inherit craneLib h-lib;
  buildRustPackage = self.callPackage ./build-rust-package.nix { };
  buildBevyPackage = self.callPackage ./build-bevy-package.nix { };
  wrapVulkanLoader = self.callPackage ./wrap-vulkan-loader.nix { };
})
