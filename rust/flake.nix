{
  description = "Rust dev shells, builders, etc.";

  inputs = {
    h-dev = {
      url = "path:../.";
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
      devShells = forAllSystems (system: {
        inherit (pkgsFor.${system}.callPackage ./shells { }) default rustGuiShell rustGtkShell;
      });

      legacyPackages = forAllSystems (
        system:
        let
          pkgs = pkgsFor.${system};
          craneLib = inputs.crane.mkLib pkgs;
          h-lib = inputs.h-dev.lib;
        in
        {
          inherit (pkgs.callPackage ./pkgs { inherit craneLib h-lib; }) buildRustPackage buildBevyPackage;
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
