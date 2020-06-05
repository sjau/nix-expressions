{ stdenv, lib, fetchzip }:

stdenv.mkDerivation rec {
    name = "vdhcoapp-${version}";
    version = "1.5.0-1";

    src = fetchzip {
        url = "https://github.com/mi-g/vdhcoapp/releases/download/v1.5.0/net.downloadhelper.coapp-${version}_amd64.tar.gz";
        sha256 = "0hmbxl30m27jj8qvpkjjw0av4qnzmc997ami4kk746jqzy0rryq2";
    };

    unpackCmd = ''
        tar -xvf "$src"
    '';

    buildPhase = ":";       # nothing to build
    installPhase = ''
        ls

        mkdir -p $out/bin
        mkdir -p $out/lib
        cp -R bin $out/bin
        cp -R converter $out/converter
        
        ls -al $out/bin
        ls -al $out/lib
        exit;
    '';

    meta = with stdenv.lib; {
        homepage = "https://github.com/mi-g/vdhcoapp";
        description = "Companion application for Video DownloadHelper browser add-on.";

        platforms = platforms.linux;
        maintainers = with maintainers; [ hyper_ch ];
    };
}

