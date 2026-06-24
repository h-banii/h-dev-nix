{
  description = "Rust dev shells, builders, etc.";

  inputs = {
    h-dev.url = "path:../.";
  };

  outputs =
    {
      nixpkgs,
      systems,
      h-dev,
      ...
    }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs (import systems);
      pkgsFor = forAllSystems (system: nixpkgs.legacyPackages.${system});
    in
    {
      devShells = forAllSystems (system: pkgsFor.${system}.callPackage ./shells { });

      formatter = forAllSystems (
        system:
        let
          inherit (h-dev.legacyPackages.${system}) mkFormatter;
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
