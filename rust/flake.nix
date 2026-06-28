{
  description = "Rust dev shells, builders, etc.";

  inputs = {
    h-dev = {
      url = "github:h-banii/h-dev-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };
    crane.url = "github:ipetkov/crane";
  };

  outputs =
    {
      nixpkgs,
      systems,
      ...
    }@inputs:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs (import systems);
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (system: rec {
        default = rust-shell;
        inherit (pkgsFor.${system}.callPackage ./shells { })
          rust-shell
          rust-gtk-shell
          rust-gui-shell
          ;
      });

      legacyPackages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          h-lib = inputs.h-dev.lib;
        in
        {
          inherit
            (pkgs.callPackage ./pkgs {
              inherit h-lib;
              flake-inputs = inputs;
            })
            buildBevyPackage
            buildRustDocs
            buildRustPackage
            wrapVulkanLoader
            ;
        }
      );

      formatter = forAllSystems (
        system:
        let
          inherit (inputs.h-dev.legacyPackages.${system}) mkFormatter;
          pkgs = pkgsFor.${system};
        in
        mkFormatter {
          formatters = [
            "treefmt"
            "cargo fmt"
          ];
          runtimeInputs = with pkgs; [
            cargo
            rustfmt
            nixfmt-tree
          ];
        }
      );
    };
}
