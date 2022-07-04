{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, autoconf-archive
, autoreconfHook
, cppunit
, libsigcxx
, openssl
, pkg-config
, zlib
}:

stdenv.mkDerivation rec {
    pname = "rakshasa-libtorrent";
    version = "0.13.8";

    src = fetchFromGitHub {
        owner = "rakshasa";
        repo = "libtorrent";
        rev = "756f70010779927dc0691e1e722ed433d5d295e1";
        hash = "sha256-uSDzOU53i0aKm0C27In+zLAAHeKMu5av90DoN5YyvsA=";
    };

    nativeBuildInputs = [
        autoconf-archive
        autoreconfHook
        pkg-config
    ];

    buildInputs = [
        cppunit
        libsigcxx
        openssl
        zlib
    ];

    patchFlags = [ "-uNp1" ];
    patches = [
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_lt-ps_all_02-better-bencode-errors_all.patch";
                        sha256 = "sha256-YHJjR2PlZ06SPPQWtDcAKZ1S5bhGjjvfMGEjVwjXHg8="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_backport_lt_all_01-partially_done_and_choke_group_fix.patch";
                        sha256 = "sha256-/LUrscRCz2/cfGKeR9YmqiD0bCQcX0QOaLLVS7iNun0="; })
        (fetchpatch {   url    = "https://raw.githubusercontent.com/sjau/nix-expressions/master/rtorrent/0.9.8_backport_lt_all_02-honor_system_file_allocate_fix.patch";
                        sha256 = "sha256-/9bWRPL18Rsi4q7c9AePc710Y0KeAKz8iSJT7ufzZvg="; })
    ];

    enableParallelBuilding = true;

    meta = with lib; {
        homepage = "https://github.com/rakshasa/libtorrent";
        description = "A BitTorrent library written in C++ for *nix, with focus on high performance and good code";
        license = licenses.gpl2Plus;
        maintainers = with maintainers; [ ebzzry codyopel ];
        platforms = platforms.unix;
    };
}
