{
  lib,
  h-lib,
  craneLib,

  writeText,
  runCommandLocal,
}:
{
  src ? null,
  srcs ? [ ],
  exts ? [ ],
  strictDeps ? true,
  ...
}@args:
let
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
    (builtins.removeAttrs args [
      "pname"
      "srcs"
      "exts"
    ])
    // {
      src = filteredSource;
    }
  );
in
craneLib.buildPackage (
  args
  // {
    src = filteredSource;
    inherit cargoArtifacts;
    inherit (craneLib.crateNameFromCargoToml { src = filteredSource; }) version;
    doCheck = false;
  }
)
