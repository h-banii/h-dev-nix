{
  buildRustPackage,
  runCommandLocal,
  ...
}:
{
  bevyAssets ? null, # removeAttrs
  pname,
  ...
}@args:
let
  package = buildRustPackage (builtins.removeAttrs args [ "bevyAssets" ]);
in
runCommandLocal pname { passthru.unwrapped = package; } (
  ''
    mkdir -p "$out/bin"
    cp -r "${package}/bin"/* "$out/bin"
  ''
  + (if bevyAssets == null then "" else ''ln -s "${bevyAssets}" "$out/bin/assets"'')
)
