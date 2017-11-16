{ stdenv, lib, qt5, sane-backends, makeWrapper, fetchurl }:

stdenv.mkDerivation rec {
    name = "master-pdf-editor--${version}";
    version = "4.3.10";

    src = fetchurl {
        url = "http://get.code-industry.net/public/master-pdf-editor-${version}_qt5.amd64.deb";
        sha256 = "1z26qjhbiyz33rm7mp8ycgl5ka0v3v5lv5i5v0b5mx35arvx2zzy";
    };
    sourceRoot = ".";
    unpackCmd = ''
        ar p "$src" data.tar.xz | tar xJ
    '';

    buildPhase = ":";       # nothing to build
    libPath = lib.makeLibraryPath [
        qt5.qtbase          # libQt5PrintSupport.so.5
        qt5.qtsvg           # libQt5Svg.so.5
        stdenv.cc.cc.lib    # libstdc++.so.6
        sane-backends       # libsane.so.1
    ];
    installPhase = ''
        mkdir -p $out/bin
        cp -R usr/share opt $out/
        # fix the path in the desktop file
        substituteInPlace \
            $out/share/applications/masterpdfeditor4.desktop \
            --replace /opt/ $out/opt/
        # symlink the binary to bin/
        ln -s $out/opt/master-pdf-editor-4/masterpdfeditor4 $out/bin/masterpdfeditor4
    '';
    postFixup = ''
        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "${libPath}" \
            $out/opt/master-pdf-editor-4/masterpdfeditor4
    '';

    meta = with stdenv.lib; {
        homepage = https://code-industry.net/masterpdfeditor/;
        description = "a multifunctional PDF Editor";
        platforms = platforms.linux;
        maintainers = [ hyper_ch ];
    };
}
