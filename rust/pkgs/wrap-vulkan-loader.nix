{
  lib,
  symlinkJoin,
  makeWrapper,
  vulkan-loader,
}:
package:
symlinkJoin {
  inherit (package) name;

  paths = [ package ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/${package.name} \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          vulkan-loader
        ]
      }"
  '';
}
