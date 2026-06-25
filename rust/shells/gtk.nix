{
  packages ? [ ],

  default,

  mkShell,

  glib-networking,
  gsettings-desktop-schemas,
  gnome,
  gtk4,
  librsvg,
  webp-pixbuf-loader,
}:
let

  schemas = gsettings-desktop-schemas;
in
mkShell {
  name = "nymphy-gtk-shell";

  inputsFrom = [ default ];
  inherit (default) RUST_SRC_PATH;

  packages = [
    gtk4
  ];

  XDG_DATA_DIRS = "${schemas}/share/gsettings-schemas/${schemas.name}:${gtk4}/share/gsettings-schemas/${gtk4.name}";
  GIO_EXTRA_MODULES = "${glib-networking}/lib/gio/modules";
  GDK_PIXBUF_MODULE_FILE = "${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
    extraLoaders = [
      librsvg
      webp-pixbuf-loader
    ];
  }}";
}
