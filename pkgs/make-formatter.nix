{
  lib,
  writeShellApplication,
}:
{ formatters, runtimeInputs }:
let
  pname =
    let
      formattersText = lib.strings.concatStringsSep "-" formatters;
    in
    "formatter-${formattersText}";
in
writeShellApplication {
  name = pname;
  inherit runtimeInputs;
  text = ''
    info() {
      echo -e "\e[01;36minfo:\e[0m $1"
    }
  ''
  + (lib.strings.concatMapStringsSep "\n" (cmd: ''
    info "Running ${cmd}..."
    ${cmd}
  '') formatters);
}
