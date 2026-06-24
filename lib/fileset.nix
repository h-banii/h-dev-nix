{ lib }:
with lib.fileset;
rec {
  fileExtFilter = ext: fileFilter (file: file.hasExt ext);
  filePfxFilter = pfx: fileFilter (file: lib.strings.hasPrefix pfx file.name);

  mapFileFilter =
    filter: list: src:
    map (arg: filter arg src) list;

  extFiles = exts: src: mapFileFilter fileExtFilter exts src;
  pfxFiles = pfxs: src: mapFileFilter filePfxFilter pfxs src;
}
