{
  lib,
  h-lib,
  flake-inputs,
  pkgs,

  writeText,
  runCommandLocal,
}:
{
  pname,
  src ? null,
  srcs ? [ ],
  exts ? [ ],
  strictDeps ? true,
  cargoPackage ? pname,
  cargoWorkspaceHack ? null,
  cargoExtraArgs ? "",
  cranePkgs ? pkgs,
  ...
}@args:
let
  craneLib = flake-inputs.crane.mkLib cranePkgs;

  filteredSource =
    with lib.fileset;
    toSource {
      root = src;
      fileset =
        with h-lib.fileset;
        unions (
          lib.lists.flatten [
            (extFiles ([ "rs" ] ++ exts) src)
            (pfxFiles [ "Cargo" ] src)
            srcs
          ]
        );
    };

  cargoArtifacts = craneLib.buildDepsOnly (
    args
    // {
      cargoExtraArgs = if cargoWorkspaceHack == null then "-p ${cargoPackage}" else "-p ${cargoWorkspaceHack}";
      src = filteredSource;
    }
  );
in
craneLib.buildPackage (
  args
  // {
    src = filteredSource;
    cargoExtraArgs = "-p ${cargoPackage} " + cargoExtraArgs;
    inherit cargoArtifacts;
    inherit (craneLib.crateNameFromCargoToml { src = filteredSource; }) version;
    doCheck = false;

    passthru = {
      docs = craneLib.cargoDoc {
        src = filteredSource;
        inherit cargoArtifacts;
      };
    };
  }
)
