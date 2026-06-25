{
  buildRustPackage,
  runCommandLocal,
  ...
}:
{
  assets ? null,
  pname,
  ...
}@args:
let
  package = buildRustPackage (builtins.removeAttrs args [ "assets" ]);
in
runCommandLocal pname { passthru.unwrapped = package; } (
  ''
    mkdir -p "$out/bin"
    cp -r "${package}/bin"/* "$out/bin"
  ''
  + (if assets == null then "" else ''ln -s "${assets}" "$out/bin/assets"'')
)
