{ lib
, stdenv
, fetchurl
, makeDesktopItem
, copyDesktopItems
, dpkg
, glibc
, gcc-unwrapped
, autoPatchelfHook
, webkitgtk
, p11-kit
, glib
, lttng-ust
, krb5
, gtk3
, openssl
, gdk-pixbuf
, librsvg
, paper-icon-theme
, makeWrapper
, wrapGAppsHook
, systemd
}:
let
  version = "2022.3.0.8";
  src = fetchurl {
    url = "https://cdn.devolutions.net/download/Linux/RDM/${version}/RemoteDesktopManager_${version}_amd64.deb";
    sha256 = "sha256-pwbS7KJzzj71V7+KVyQPq/oAeTs0d39w4ooexmxWj9g=";
  };

in
stdenv.mkDerivation rec {
  name = "remotedesktopmanager-${version}";
  system = "x86_64-linux";

  inherit src;

  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
    dpkg
    makeWrapper
    wrapGAppsHook
  ];

  runtimeDependencies = [
    (lib.getLib systemd)
  ];

  buildInputs = [
    glibc
    gcc-unwrapped
    webkitgtk
    p11-kit
    glib
    lttng-ust
    krb5
    gtk3
    openssl
    gdk-pixbuf
    librsvg
    paper-icon-theme
  ];

  unpackPhase = "true";

  installPhase = ''
    dpkg-deb -X $src $out
    substituteInPlace $out/bin/remotedesktopmanager \
        --replace /usr/lib/ $out/usr/lib/

    patchelf --replace-needed liblttng-ust.so.0 liblttng-ust.so.1 $out/usr/lib/devolutions/RemoteDesktopManager/libcoreclrtraceptprovider.so
    patchelf --add-needed libgtk-3.so.0 $out/usr/lib/devolutions/RemoteDesktopManager/RemoteDesktopManager

    wrapProgram $out/bin/remotedesktopmanager \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath buildInputs} \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE"

    chmod 755 $out
  '';

  meta = {
    description = "Devolutions Remote Desktop Manager Enterprise centralizes all remote connections on a single platform that is securely shared between users and across the entire team.";
    homepage = "https://remotedesktopmanager.com/";
    license = lib.licenses.unfree;
    maintainers = with stdenv.lib.maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
