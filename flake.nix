{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, systems, ... }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs (import systems);
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      legacyPackages = forAllSystems (system: {
        mkFormatter = pkgsFor.${system}.callPackage ./pkgs/make-formatter.nix { };
      });

      formatter = forAllSystems (system: pkgsFor.${system}.nixfmt-tree);
    };
}
