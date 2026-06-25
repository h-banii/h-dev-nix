{
  lib,
  symlinkJoin,
  makeWrapper,
  vulkan-loader,
}:
package:
symlinkJoin {
  name = package.pname;

  paths = [ package ];

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/nvim \
      --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          vulkan-loader
        ]
      }"
  '';
}
