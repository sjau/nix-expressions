{ stdenv, lib, fetchurl, ncurses5, openssl, zlib, curl, xmlrpc_c}:
stdenv.mkDerivation rec {
    name = "rtorrent-ps_${version}";
    version = "0.9.6-PS-1.0-104";

    src = fetchurl {
        name = "rtorrent-ps_${version}_amd64.deb";
        url = "https://bintray.com/pyroscope/rtorrent-ps/download_file?file_path=rtorrent-ps_${version}-g07be19e~vivid_amd64.deb";
        sha256 = "fd2159dc4853a3f3bec25aa84572bb310a0e42111199074e029b2248e0f7e398";
    };
    sourceRoot = ".";
    unpackCmd = ''
        ar p "$src" data.tar.gz | tar xz
    '';

    buildPhase = ":";       # nothing to build
    libPath = lib.makeLibraryPath [
        ncurses5            # libncursesw.so.5
        stdenv.cc.cc.lib    # libstdc++.so.6
        openssl             # libssl.so.1.0.0
        zlib                # libz.so.1
        curl                # libcurl.so.4
        xmlrpc_c            # libxmlrpc_xmlparse.so.3
    ];

    installPhase = ''
        mkdir -p $out/bin
        cp opt/rtorrent/bin/rtorrent $out/bin/
        cp -R opt/rtorrent/lib $out/
        # Remove all the symlinks
        find $out/lib -type l -exec rm -f {} \;
        # Create proper symlinks to provided libraries
        ln -s $out/lib/libcares.so.2.1.0 $out/lib/libcares.so
        ln -s $out/lib/libcares.so.2.1.0 $out/lib/libcares.so.2
        ln -s $out/lib/libcurl.so.4.4.0 $out/lib/libcurl.so
        ln -s $out/lib/libcurl.so.4.4.0 $out/lib/libcurl.so.4
        ln -s $out/lib/libtorrent.so.19.0.0 $out/lib/libtorrent.so
        ln -s $out/lib/libtorrent.so.19.0.0 $out/lib/libtorrent.so.19
        ln -s $out/lib/libxmlrpc_cpp.so.8.43 $out/lib/libxmlrpc_cpp.so
        ln -s $out/lib/libxmlrpc_cpp.so.8.43 $out/lib/libxmlrpc_cpp.so.8
        ln -s $out/lib/libxmlrpc_packetsocket.so.8.43 $out/lib/libxmlrpc_packetsocket.so
        ln -s $out/lib/libxmlrpc_packetsocket.so.8.43 $out/lib/libxmlrpc_packetsocket.so.8
        ln -s $out/lib/libxmlrpc_server_cgi++.so.8.43 $out/lib/libxmlrpc_server_cgi++.so
        ln -s $out/lib/libxmlrpc_server_cgi++.so.8.43 $out/lib/libxmlrpc_server_cgi++.so.8
        ln -s $out/lib/libxmlrpc_server_pstream++.so.8.43 $out/lib/libxmlrpc_server_pstream++.so
        ln -s $out/lib/libxmlrpc_server_pstream++.so.8.43 $out/lib/libxmlrpc_server_pstream++.so.8
        ln -s $out/lib/libxmlrpc_server.so.3.43 $out/lib/libxmlrpc_server.so
        ln -s $out/lib/libxmlrpc_server.so.3.43 $out/lib/libxmlrpc_server.so.3
        ln -s $out/lib/libxmlrpc_server++.so.8.43 $out/lib/libxmlrpc_server++.so
        ln -s $out/lib/libxmlrpc_server++.so.8.43 $out/lib/libxmlrpc_server++.so.8
        ln -s $out/lib/libxmlrpc.so.3.43 $out/lib/libxmlrpc.so
        ln -s $out/lib/libxmlrpc.so.3.43 $out/lib/libxmlrpc.so.3
        ln -s $out/lib/libxmlrpc++.so.8.43 $out/lib/libxmlrpc++.so
        ln -s $out/lib/libxmlrpc++.so.8.43 $out/lib/libxmlrpc++.so.8
        ln -s $out/lib/libxmlrpc_util.so.3.43 $out/lib/libxmlrpc_util.so
        ln -s $out/lib/libxmlrpc_util.so.3.43 $out/lib/libxmlrpc_util.so.3
        ln -s $out/lib/libxmlrpc_util++.so.8.43 $out/lib/libxmlrpc_util++.so
        ln -s $out/lib/libxmlrpc_util++.so.8.43 $out/lib/libxmlrpc_util++.so.8
        ln -s $out/lib/libxmlrpc_xmlparse.so.3.43 $out/lib/libxmlrpc_xmlparse.so
        ln -s $out/lib/libxmlrpc_xmlparse.so.3.43 $out/lib/libxmlrpc_xmlparse.so.3
        ln -s $out/lib/libxmlrpc_xmltok.so.3.43 $out/lib/libxmlrpc_xmltok.so
        ln -s $out/lib/libxmlrpc_xmltok.so.3.43 $out/lib/libxmlrpc_xmltok.so.3
        cp -R usr/share $out/
    '';
    postFixup = ''
    echo "$libPath" > /tmp/libPath.txt
        patchelf \
            --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
            --set-rpath "$libPath:$out/lib" \
            $out/bin/rtorrent
        patchelf --set-rpath "$libPath:$out/lib" $out/lib/libtorrent.so.19.0.0
    '';

    meta = with stdenv.lib; {
        homepage = https://github.com/pyroscope/rtorrent-ps;
        description = "Extended rTorrent distribution with UI enhancements, colorization, and some added features.";
        platforms = platforms.linux;
        maintainers = [ hyper_ch ];
    };
}
