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
      cargoExtraArgs = if cargoWorkspaceHack == null then "-p ${pname}" else "-p ${cargoWorkspaceHack}";
      src = filteredSource;
    }
  );
in

craneLib.cargoDoc (
  args
  // {
    pname = "${pname}-docs";
    src = filteredSource;
    inherit cargoArtifacts;
    cargoExtraArgs = "-p ${pname} --lib" + cargoExtraArgs;
  }
)
