{ stdenv, fetchurl, fetchpatch, pkgconfig, libtool, autoconf, automake, cppunit, openssl, libsigcxx, zlib }:

stdenv.mkDerivation rec {
    name = "libtorrent-${lt_version}";
    lt_version = "0.13.6";

    src = fetchurl {
        name = "libtorrent-ps-${lt_version}";
        url = "https://bintray.com/artifact/download/pyroscope/rtorrent-ps/libtorrent-${lt_version}.tar.gz";
        sha256 = "012s1nwcvz5m5r4d2z9klgy2n34kpgn9kgwgzxm97zgdjs6a0f18";
    };

    unpackCmd = ''
        tar xvzf "$src"
    '';

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ libtool autoconf automake cppunit openssl libsigcxx zlib ];

    patchFlags = [ "-uNp1" ];
    patches = [
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/lt-ps-honor_system_file_allocate_all.patch";
                        sha256 = "1dd5zrm7qqkbx2rayfahsil7scca8lqzvq432c29vi97ddgh6f2m"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/lt-ps-log_open_file-reopen_all.patch";
                        sha256 = "1g0sx9ywdgcn4zw6kwk24px4k82hjqfinwn0sz0hf68q1ad5qlai"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/lt-open-ssl-1.1.patch";
                        sha256 = "1wm9kr2y874hrdyc4wizp8bv4nwqy9yvirvpfbisw1qknvflzrsa"; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/pyroscope/rtorrent-ps/master/patches/lt-base-cppunit-pkgconfig.patch";
                        sha256 = "17z0nrhiiylzh73f1rzmbx7kbmc8d2vp3bwad5i3cgfyzwk0z5ya"; })
    ];

    preConfigure = "./autogen.sh";

    meta = with stdenv.lib; {
        homepage = "http://rtorrent.net/downloads/";
        description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";

        platforms = platforms.linux;
        maintainers = with maintainers; [ hyper_ch ];
    };
}

